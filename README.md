# Signals
These are projects for various courses using MATLAB.

 - dtmfdial: By giving numbers and hitting play, the dial sound correspoinding to that number is played.
 - prj5: A simple project that creates sample voltages then plots them.
 - SleepAnalysis: Takes accelerometer and noise data taken from a sleeping person, and analyzes how many REM cycles the person went through in the night.
 - radarSim: By far the most complicated project. First, a 1 GHz wave is upsampled to 8GHz by multiplying by 7 GHz carrier, then applying a bandpass filter (convolution with finite sinc function). This signal is then "sent" to a radar and back (this is simply a time delay for our purposes). Artificial noise is then added to both the real and imaginary parts of the signal to replicate the real world. Tis signal is then downconverted back to 1 GHz via a matching filter.
