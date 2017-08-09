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

#
# Creates a section heading with 'text'
# and optional wait time 'wait'.
# Default wait time is 2 seconds.
#
def SECTION(text, wait = None):
    stars = "#" * (len(text) + 4)
    print("\n" + stars)
    print("# " + text + " #")
    print(stars + "\n")

    if wait == None:
        SECTION_SLEEP(2)
    else:
        SECTION_SLEEP(wait)

#
# Sleep wrapper to allow quick disabling
# of wait time between sections.
#
def SECTION_SLEEP(time):
    if 'SECTION_WAIT' in globals() and not SECTION_WAIT:
        return
    sleep(time)
