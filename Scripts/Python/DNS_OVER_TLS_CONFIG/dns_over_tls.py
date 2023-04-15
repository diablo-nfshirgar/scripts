import logging
import socket
import ssl
import _thread

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def init_request(socket_encrypt, query):
    query_tcp = init_query(query)
    socket_encrypt.send(query_tcp)
    result = socket_encrypt.recv(1024)

    return result

def init_query(query):
    pre_length = b"\x00" + bytes(chr(len(query)), encoding='utf-8')
    prefixed_query = pre_length + query

    return prefixed_query

def handle_req(data, addr, cf_ip):
  socket_encrypt = connection_encrypt(cf_ip)
  tcp_result = init_request(socket_encrypt, data)
  udp_result = tcp_result[2:]
  sock.sendto(udp_result,addr)

def connection_encrypt(cf_ip):
    # Make an encrypted tcp connection
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(15)

    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    context.verify_mode = ssl.CERT_REQUIRED
    context.load_verify_locations('/etc/ssl/certs/ca-certificates.crt')

    socket_encrypt = context.wrap_socket(sock, server_hostname=cf_ip)
    socket_encrypt.connect((cf_ip , cf_port))

    return socket_encrypt

if __name__ == '__main__':
    cf_ip = '1.1.1.1'
    cf_port = 853
    docker_ip = '172.17.0.2' # Assuming there are no prior docker containers running
    docker_port = 950

    print("Powering on the connection on container...")
    try:
        # Initiate udp thread
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.bind((docker_ip, docker_port))

        while True:
            data,addr = sock.recvfrom(1024)
            _thread.start_new_thread(handle_req,(data, addr, cf_ip))

    except Exception as e:
        logger.error(str(e))
        print("There was an error encountered:", e)
        sock.close()
