import sys
import matplotlib.pyplot as plt
import numpy as np

def main():
    with plt.xkcd():
        time = np.arange(0, 100, 0.01);
        wave_1 = np.sin(time)
        wave_2 = np.sin(time * 0.9)
        wave_3 = np.sin(time * 0.8)
        wave_sum = wave_1 + wave_2 + wave_3

        fig = plt.figure()
        ax = fig.add_axes((0.05, 0.05, 0.9, 0.9), frame_on=False)
        plt.xticks([])
        plt.yticks([])

        plt.plot(time, wave_1 - 0, linewidth=0.25)
        plt.plot(time, wave_2 - 3, linewidth=0.25)
        plt.plot(time, wave_3 - 6, linewidth=0.25)
        plt.plot(time, wave_sum - 12, linewidth=0.75)

    plt.savefig(sys.argv[1])

if __name__ == '__main__':
    main()
