function paramFixed = loadSensoryNoiseParameters(paramFixed)
% sensory noise just makes learning challenging. Setting these to zero
% just lowers the noise in the behavior without affecting the qualitative
% trends, but increasing these eventually kills learning or makes the biped
% unstable and fall

%% multiplicative noise for energy measurements

paramFixed.noiseEnergySensory_Multiplicative = 0.0001; % this is multiplicative noise
paramFixed.noiseEnergySensory_Additive = 0;

%% noise terms
paramFixed.velocitySensoryNoise = 0; 
% this is additive sensory noise in velocity upon which feedback control
% happens

end % code checked