clear all
clc
close all

s = tf('s')

L = (s^2 + 2*s + 50)/(s^3 + 6*s^2 + 11*s + 6)

[DM,MM] = diskmargin(L)
diskmarginplot(DM.GainMargin,'disk')