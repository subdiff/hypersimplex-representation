#
# Simple test if 's' is a number.
#
def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

#
# Waiting indicator for long lasting computations.
# A static status message might be set on init or start.
#
class WaitAnimation:

    def __init__(self, message=None):
        self.running = False
        if message != None:
            self.message = message

    def start(self, message=None):
        if message != None:
            self.message = message

        self.running = True

        t = threading.Thread(target=self.animate)
        t.start()

    def stop(self):
        self.running = False
        sys.stdout.write("\r\033[K")

    def animate(self):
        i = 0
        while self.running:
            i = (i + 1)%4
            sys.stdout.write("\r" + self.message + "."*i)
            sys.stdout.write("\033[K")
            time.sleep(0.5)
