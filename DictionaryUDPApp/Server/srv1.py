import socket

dictionary = {}
with open("engRus.txt") as f:
    for line in f:
        (key, val) = line.split()
        dictionary[key] = val

# Set up a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Bind the socket to a specific address and port
server_address = ('localhost', 10001)
print('Starting up on %s port %s' % server_address)
sock.bind(server_address)

# Keep track of connected clients
clients = set()

while True:
    # Receive a message from a client
    print('\nWaiting for a connection...')
    data, address = sock.recvfrom(4096)
    print('Received %s bytes from %s' % (len(data), address))
    message = data.decode()

    # Add the client to the set of connected clients
    clients.add(address)

    # Print the message and the set of connected clients
    print('Received message: %s' % message)
    print('Connected clients: %s' % clients)

    # Send a response back to the client
    response = dictionary.setdefault(message, "Word not found...")
    
    print("Sending message back")
    sock.sendto(response.encode(), address)

    # If the client disconnected, remove them from the set of connected clients
    if message == 'disconnect':
        print('Client disconnected')
        clients.remove(address)
        
