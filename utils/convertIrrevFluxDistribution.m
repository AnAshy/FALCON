function vRev = convertIrrevFluxDistribution(vIrrev, matchRev)
%convertInrrevFluxDistribution  Convert irreversible flux distribution to
%reversible
%
% vRev = covertIrrevFluxDistribution(vIrrev,matchRev)
%
%INPUTS
% model         model structure
% vIrrev        Irreversible flux distribution
% matchRev      Vector mapping irreversible fluxes to reversible fluxes 
%               (Generated by convertToIrreversible)
%
%OUTPUT
% vRev          Reversible flux distribution
%
% Markus Herrgard 1/30/07
%
% Brandon Barker, Yiping Wang 6/23/2013
%     - correctly negate strictly backward reactions
% 
processedFlux = false*ones(length(vIrrev),1);

vRev = [];

for i = 1:length(vIrrev)
    if (~processedFlux(i))
        vRevlen = length(vRev);
        if matchRev(i) > 0
            vRev(end+1) = vIrrev(i)-vIrrev(matchRev(i));
            processedFlux(matchRev(i)) = true;
        elseif matchRev(i) < 0
            if mod(matchRev(vRevlen+1), 1) > 0                
                vRev(vRevlen+1) = -vIrrev(i);
            else
                vRev(vRevlen+1) = vIrrev(i);
	    end
        else
            disp(['Warning: rev_rxn ' num2str(vRevlen+1) ', irrev rxn ' ...
                  num2str(i) ' missed in matchRev.']);
        end
        processedFlux(i) = true;
    end
end

vRev = columnVector(vRev);