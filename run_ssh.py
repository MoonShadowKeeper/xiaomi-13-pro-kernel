import pty
import os
import sys
import time

ip = "209.74.86.53"
port = "22022"
pwd = "123543Moon03!"
cmd = sys.argv[1] if len(sys.argv) > 1 else "uname -a"

command = f"ssh -o StrictHostKeyChecking=no root@{ip} -p {port} '{cmd}'"

pid, fd = pty.fork()
if pid == 0:
    os.execvp("ssh", ["ssh", "-o", "StrictHostKeyChecking=no", f"root@{ip}", "-p", port, cmd])
    sys.exit(0)
else:
    output = b""
    while True:
        try:
            data = os.read(fd, 1024)
        except OSError:
            break
        if not data:
            break
        output += data
        if b"password:" in output.lower():
            os.write(fd, pwd.encode() + b"\n")
            output = b"" # reset output after password
            
    print(output.decode(errors='ignore'))
    os.waitpid(pid, 0)
