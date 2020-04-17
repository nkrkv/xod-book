import sys
import matplotlib.pyplot as plt
import numpy as np

def main():
    with plt.xkcd(scale=0.7):
        time = np.arange(0, 100, 0.01);
        wave_info = np.sin(time / 7)
        wave_carry = np.sin(time * 2)
        wave_fm = np.sin(time + 6 * wave_info)

        fig = plt.figure(figsize=(8.0, 3.0), linewidth=0.25)

        subplot1 = fig.add_subplot(3, 1, 1)
        subplot1.axis('off')
        subplot1.plot(time, wave_info, linewidth=0.25)

        subplot2 = fig.add_subplot(3, 1, 2)
        subplot2.axis('off')
        subplot2.plot(time, wave_carry, linewidth=0.25)

        subplot3 = fig.add_subplot(3, 1, 3)
        subplot3.axis('off')
        subplot3.plot(time, wave_fm, linewidth=0.75)

        fig.tight_layout()

    fig.savefig(sys.argv[1])

if __name__ == '__main__':
    main()
