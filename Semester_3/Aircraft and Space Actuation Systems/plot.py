import matplotlib.pyplot as plt

# x-axis data
x = [4,	15	,50	,100,	150,	185]

# y1-axis data
y1_var1 = [57.43,	189.76,	360	,360,	360	,362]
y1_var2 = [2.49	,5.92,	8.34,	6.59	,4.87,	4.2]
y1_var3 = [13.42	,42.82,	53.52,	52.54,	66.35,	62.14]
y1_var4 = [34.28	,111.43	,188.36	,152.81,	118.52,	92.32]
y1_var5 = [2.98	,13.57	,27.67	,22.76,	17.69,	15.63]

# y2-axis data
y2_var1 = [68.27,	57.83,	47.16,	35.13,	24.25,	17.78]

# Create a figure and an axis named ax1
fig, ax1 = plt.subplots()

# Create a twinx() of the original axis and set it to ax2
ax2 = ax1.twinx()

# plot y1-axis data
ax1.plot(x, y1_var1, 'g-', label='Total mass achieved')
ax1.plot(x, y1_var2, 'b-', label='Propeller mass')
ax1.plot(x, y1_var3, 'r-', label='Motor mass')
ax1.plot(x, y1_var4, 'c-', label='Battery mass')
ax1.plot(x, y1_var5, 'm-', label='Structural mass')

# plot y2-axis data
ax2.plot(x, y2_var1, 'y-', label='Flight time achieved')

# add legend
ax1.legend(loc='center right')
ax2.legend(loc='upper right')

# add axis titles
ax1.set_xlabel('specification:Payload mass in kg')
ax1.set_ylabel('Mass in kgs')
ax2.set_ylabel('Flight time in mins')

# show plot
plt.show()


