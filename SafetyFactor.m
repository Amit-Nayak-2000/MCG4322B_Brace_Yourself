classdef SafetyFactor < handle
    %SAFETYFACTOR
    %Contains all safety factors resulting from stress calculations
    
    properties
        % Superior
        sigma_sx
        sigma_s1y
        sigma_s2y
        sigma_s3y
        sigma_sbend1
        sigma_sbend2
        sigma_srupture
        tau_s1
        tau_s2
        tau_s3
        
        % Inferior
        sigma_ix
        sigma_i1y
        sigma_i2y
        sigma_i3y
        sigma_ibend1
        sigma_ibend2
        tau_i1
        tau_i2
        tau_i3
        sigma_irupture 
        
        % Anterior
        sigma_a1y
        sigma_a2y
        sigma_abend
        tau_a1
        tau_a2
        sigma_arupture1
        sigma_arupture2
        
        % Posterior
        sigma_p1y
        sigma_p2y
        sigma_pbend
        tau_p1
        tau_p2
        sigma_prupture1
        sigma_prupture2
        
        % Velcro
        tau_vt
        tau_vc
        
        % Springs
        
        
        % Bolts
        tau_sa 
        tau_sp 
        tau_ia 
        tau_ip

        
        % Bearings
        
        
        
    end
    
end