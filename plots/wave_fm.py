import sys
import matplotlib.pyplot as plt
import numpy as np

def main():
    with plt.xkcd(scale=0.7):
        time = np.arange(0, 100, 0.01);
        wave_info = np.sin(time / 7)
        wave_carry = np.sin(time * 2)
        wave_fm = np.sin(time + wave_info * 6)

        fig = plt.figure()
        ax = fig.add_axes((0.05, 0.05, 0.9, 0.9), frame_on=False)
        plt.xticks([])
        plt.yticks([])

        plt.plot(time, wave_info - 0, linewidth=0.25)
        plt.plot(time, wave_carry - 3, linewidth=0.25)
        plt.plot(time, wave_fm - 6, linewidth=0.75)

    plt.savefig(sys.argv[1])

if __name__ == '__main__':
    main()
