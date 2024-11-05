% Deriving Analytical Solutions Using Symbolic Matrix Structural Analysis:
% Part 1 – Continuous Beams
% Version 1.0 - 6 November 2024
% By Vagelis Plevris - vplevris@gmail.com

clear all, close all, clc

addpath('examples') % The folder containing the 5 examples

syms L EI ki wi x real % Define some useful symbolic variables
syms P P1 P2 a b w real % Define some useful symbolic variables

example_3 % Example to run - Five examples are available
% Change this to run another input file

NumElements = size(Lengths,1); NumNodes=NumElements+1; % Number of Elements and Nodes
NumDOFs = 2*NumNodes; % Number of Degrees of Freedom (total)
Ktot = sym(zeros(NumDOFs));  % Total Stiffness Matrix
Stot = sym(zeros(NumDOFs,1)); % Equivalent Nodal Loads Vector

for i=1:NumElements % Form the Total Stiffness Matrix Ktot and the Vector Stot
    Li = Lengths(i); wi = UniformLoads(i);
    ki=EI/Li^3*[  12     6*Li    -12     6*Li ;
                6*Li   4*Li^2  -6*Li   2*Li^2 ;
                 -12    -6*Li     12    -6*Li ;
                6*Li   2*Li^2  -6*Li   4*Li^2 ];
    Ktot(2*i-1:2*i+2,2*i-1:2*i+2) = Ktot(2*i-1:2*i+2,2*i-1:2*i+2) + ki;
    Si = [wi*Li/2 ; wi*Li^2/12  ; wi*Li/2 ; -wi*Li^2/12];
    Stot(2*i-1:2*i+2) = Stot(2*i-1:2*i+2) + Si;
end

Ptot = sym(zeros(NumDOFs,1)); % Total vector of external forces P
Ptot = reshape(PointLoads',NumDOFs,1) + Stot; % We add the Equivalent Nodal Loads Vector

SupportsR = reshape(Supports',NumDOFs,1); % Vector of Supports [0 or 1], Reshaped
indicesFree = find(~SupportsR); % The Free DOFs
indicesConstrained = find(SupportsR); % The Constrained DOFs

Kff = Ktot(indicesFree, indicesFree); % Kff Corresponding to the Free (Active) DOFs
Pf = Ptot(indicesFree); % The Forces on the Free DOFs (Including Equivalent Nodal Loads)
Uf = Kff\Pf; % The Displacements of the Free DOFs

Utot = sym(zeros(NumDOFs,1)); % Total Displacements (All DOFs) - Initialize
Utot(indicesFree) = Uf; % Add contributions from Uf (Displacements of the Free DOFs)

Ftot = Ktot*Utot - Stot; % All forces, including all external loads and all support reactions

% Special Case: Add to Reactions Any External Forces Directly on Supported DOFs (if any)
ForcesOnSupports = zeros(size(PointLoads)); % Initialize the Matrix
ForcesOnSupports(Supports == 1) = PointLoads(Supports == 1); % Add Forces Directly on Supports
ForcesOnSupportsVec = reshape(ForcesOnSupports', NumDOFs, 1); % Reshape as Vector
Ftot = Ftot - ForcesOnSupportsVec; % Subtract to Take them Into Account for Equilibrium

FReactions = Ftot(indicesConstrained); % Final Support Reactions only, on constrained DOFs

ElemForces = sym(zeros(NumElements,4)); % Initialize the Matrix with Element Forces

for i=1:NumElements;
    Li = Lengths(i); wi = UniformLoads(i);
    ki=EI/Li^3*[  12     6*Li    -12     6*Li ;
                6*Li   4*Li^2  -6*Li   2*Li^2 ;
                 -12    -6*Li     12    -6*Li ;
                6*Li   2*Li^2  -6*Li   4*Li^2 ];
    Ui = Utot(2*i-1:2*i+2); % Displacements of the specific Element
    Si = [wi*Li/2 ; wi*Li^2/12  ; wi*Li/2 ; -wi*Li^2/12]; % Equivalent Nodal Loads for the specific Element
    Fi = ki*Ui - Si; % We Subtract the Equivalent Nodal Loads
    ElemForces(i,:) = Fi';
end


%% Analysis Complete, Report the Analysis Results
UNodes=reshape(Utot,2,NumNodes)'; % Reshape to get NumNodes Rows and 2 columns
UNodes_Final=simplify(UNodes) % Simplify the Expressions
FReactions_Final=simplify(FReactions) % Simplify the Expressions
ElemForces_Final=simplify(ElemForces) % Simplify the Expressions


%% The Analysis Part and Reporting the Results (on Nodes) are Completed
% The next part is for calculating the extremum bending moments and their
% locations for each Element (with uniform load on)

ind = 0; % Index to Count Elements
for i = 1:NumElements;
    q = UniformLoads(i); % Uniform Load on Element
    if q ~= 0; % In Case There is Uniform Load on Element
        ind = ind+1;
        Vi = ElemForces_Final(i,1); % Shear Force Vi at Start Node i
        Mi = ElemForces_Final(i,2); % Bending Moment Mi at Start Node i (positive when counter-clockwise)
        M_Extr_Elem(ind) = i; % Element ID for the Element Examined
        x_Extr_M(ind) = -Vi/q; % Location of the Extremum Moment
        M_Extr_M(ind) = -Mi - Vi^2/(2*q); % Value of the Extremum Moment
        % M_Extr_M (unlike Mi) is positive when it induces tension in the bottom fiber of the beam
    end
end

if ind ~= 0 % In Case There are Elements with Uniform Loads on
    MExtrSpan = [M_Extr_Elem ; % Report the Element Numbering
                 x_Extr_M    ; % Report the Locations of the Extremum Moments
                 M_Extr_M    ]' % Report the Values of the Extremum Moments
end



