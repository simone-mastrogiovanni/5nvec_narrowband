% ana_peakfr

load peakfrc7
load peakfr8
load peakfr10

peaksc7=gd_peaks(peakfrc7,100)
peaks8=gd_peaks(peakfr8,100)
peaks10=gd_peaks(peakfr10,60)

fc7=x_gd(peaksc7);
f8=x_gd(peaks8);
f10=x_gd(peaks10);

spc7=ev_spec(fc7,1,0,0,40,4)
sp8=ev_spec(f8,1,0,0,40,4)
sp10=ev_spec(f10,1,0,0,40,4)