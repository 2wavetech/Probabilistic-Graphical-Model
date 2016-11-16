function submit(part)
  addpath('./lib');

  conf.assignmentKey = 'ZPEHfwNgEealXw52htHS4Q';
  conf.itemName = 'Decision Making';

  conf.partArrays = { ...
    { ...
      'ABz0W', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'B5ynW', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'LYITS', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'fJqCV', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'I0Bvr', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      '37kCm', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'D2EEw', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      '2AHBQ', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'aFNuE', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'Th2m9', ...
      { '' }, ...
      '', ...
    }, ...
  };

  conf.output = @output;
  submitWithConfiguration(conf);

end

% specifies which parts are test parts
function result = isTest(partIdx)
  if (mod(partIdx, 2) == 0)
      result = true;
  else
      result = false;
  end
end




function out = output(partId, auxstring)
 if partId == 9
    load 'FullI.mat';
    out = SerializeFloat(SimpleCalcExpectedUtility(FullI));
    clear FullI;

  elseif partId == 10

    load 'FullI.mat';
    Fe = FullI.RandomFactors;
    Fe = ObserveEvidence(Fe, [3 2], 1);
    FullI.RandomFactors = Fe;
    out = SerializeFloat(SimpleCalcExpectedUtility(FullI));
    clear FullI;
    clear Fe;

  elseif partId == 1

    load 'FullI.mat';
    out = SerializeFactorsFg(CalculateExpectedUtilityFactor(FullI));
    clear FullI;

  elseif partId == 2

    load 'FullI.mat';
    Fe = FullI.RandomFactors;
    Fe = ObserveEvidence(Fe, [3 2], 1);
    FullI.RandomFactors = Fe;
    out = SerializeFactorsFg(CalculateExpectedUtilityFactor(FullI));
    clear FullI;
    clear Fe;

  elseif partId == 3

    load 'FullI.mat';
    [meu optdr] = OptimizeMEU(FullI);
    out = SerializeMEUOptimization(meu, optdr);
    clear FullI;
    
  elseif partId == 4

    load 'FullI.mat';
    Fe = FullI.RandomFactors;
    Fe = ObserveEvidence(Fe, [3 2], 1);
    FullI.RandomFactors = Fe;
    [meu optdr] = OptimizeMEU(FullI);
    out = SerializeMEUOptimization(meu, optdr);
    clear FullI;
    clear Fe;

  elseif partId == 5

    load 'MultipleUtilityI.mat';
    [meu optdr] = OptimizeWithJointUtility(MultipleUtilityI);
    out = SerializeMEUOptimization(meu, optdr);
    clear MultipleUtility;

  elseif partId == 6

    load 'MultipleUtilityI.mat';
    Fe = MultipleUtilityI.RandomFactors;
    Fe = ObserveEvidence(Fe, [3 1], 1);
    MultipleUtilityI.RandomFactors = Fe;
    [meu optdr] = OptimizeWithJointUtility(MultipleUtilityI);
    out = SerializeMEUOptimization(meu, optdr);
    clear MultipleUtilityI;
    clear Fe;

  elseif partId == 7

    load 'MultipleUtilityI.mat';
    [meu optdr] = OptimizeLinearExpectations(MultipleUtilityI);
    out = SerializeMEUOptimization(meu, optdr);
    clear MultipleUtilityI;

  elseif partId == 8

    load 'MultipleUtilityI.mat';
    Fe = MultipleUtilityI.RandomFactors;
    Fe = ObserveEvidence(Fe, [3 1], 1);
    MultipleUtilityI.RandomFactors = Fe;
    [meu optdr] = OptimizeLinearExpectations(MultipleUtilityI);
    out = SerializeMEUOptimization(meu, optdr);
    clear MultipleUtilityI;
    clear Fe;

  end
% end of output function.
end


function out = SerializeFloat( x )
  out = sprintf('%.4f', x);
end

function out = SerializeTreeFg(C)
% Serializes a factor struct array into the .fg format for libDAI
% http://cs.ru.nl/~jorism/libDAI/doc/fileformats.html
%
% To avoid incompatibilities with EOL markers, make sure you write the
% string to a file using the appropriate file type ('wt' for windows, 'w'
% for unix)
totalLines = length(C.nodes) + length(C.edges(1,:)) + 3;

lines = cell(totalLines, 1);

newInd = 1;
lines{newInd} = sprintf('%d\n', numel(C.nodes));

for i = 1 : length(C.nodes),
    newInd = newInd + 1;
    lines{newInd} = sprintf('%s\n', num2str(C.nodes{i}));
end


newInd = newInd + 1;
lines{newInd} = sprintf('\n%d\n', numel(C.edges(1,:)));

for j = 1 : length(C.edges),
    newInd = newInd + 1;
    lines{newInd} = sprintf('%s\n', num2str(C.edges(j, :)));
end


lines{newInd + 1} = SerializeFactorsFg(C.factorList);

out = sprintf('%s', lines{:});

end

function out = SerializeCompactTree(C)
% Serializes a factor struct array into the .fg format for libDAI
% http://cs.ru.nl/~jorism/libDAI/doc/fileformats.html
%
% To avoid incompatibilities with EOL markers, make sure you write the
% string to a file using the appropriate file type ('wt' for windows, 'w'
% for unix)
totalLines = length(C.edges(1,:)) + 2;
lines = cell(totalLines, 1);

newInd = 1;
lines{newInd} = sprintf('\n%d\n', numel(C.edges(1,:)));

for j = 1 : length(C.edges),
    newInd = newInd + 1;
    lines{newInd} = sprintf('%s\n', num2str(C.edges(j, :)));
end


lines{newInd + 1} = SerializeFactorsFg(C.cliqueList);
out = sprintf('%s', lines{:});

end

function out = SerializeFactorsFg(F)
% Serializes a factor struct array into the .fg format for libDAI
% http://cs.ru.nl/~jorism/libDAI/doc/fileformats.html
%
% To avoid incompatibilities with EOL markers, make sure you write the
% string to a file using the appropriate file type ('wt' for windows, 'w'
% for unix)

  lines = cell(5*numel(F) + 1, 1);

  lines{1} = sprintf('%d\n', numel(F));
  lineIdx = 2;
  for i = 1:numel(F)
    lines{lineIdx} = sprintf('\n%d\n', numel(F(i).var));
    lineIdx = lineIdx + 1;

    lines{lineIdx} = sprintf('%s\n', num2str(F(i).var(:)')); % ensure that we put in a row vector
    lineIdx = lineIdx + 1;
    
    lines{lineIdx} = sprintf('%s\n', num2str(F(i).card(:)')); % ensure that we put in a row vector
    lineIdx = lineIdx + 1;

    lines{lineIdx} = sprintf('%d\n', numel(F(i).val));
    lineIdx = lineIdx + 1;

    % Internal storage of factor vals is already in the same indexing order
    % as what libDAI expects, so we don't need to convert the indices.
    vals = [0:(numel(F(i).val) - 1); F(i).val(:)'];
    lines{lineIdx} = sprintf('%d %0.8g\n', vals);
    lineIdx = lineIdx + 1;
  end

  out = sprintf('%s', lines{:});

end


function out = SerializeMEUOptimization(meu, optdr)
  optdr = SortFactorVars(optdr);
  optdr_part = SerializeFactorsFg(optdr);
  out = sprintf('%s\n%.4f\n', optdr_part, meu);
end


function [P, messages] = UnserializeTreeAndMessagesFg(str)
    index = find(str == '#');
    P = UnserializeCompactTree(str(1:index-1));
    remaining = str(index+1 : length(str));
    
    factors = UnserializeFactorsFgOctave(remaining);
    s = (length(factors))^0.5;
    messages = reshape(factors, s,s);
    
end


function F = UnserializeFactorsFgOctave(str)
%UnserializeFactorsFg Converts a string representing factors in the libDAI
%.fg format into a struct array of factors
% http://cs.ru.nl/~jorism/libDAI/doc/fileformats.html
% Rewritten for Octave compatibility using strtok instead of textscan
% In Octave, double quoted strings allow for escape sequences!

[tok, str] = strtok(str);
numFactors = sscanf(tok, '%d');

while (~nnz(numFactors))
    [tok, str] = strtok(str, char(10));
    numFactors = sscanf(tok, '%d');
end

F(numFactors) = struct('var', [], 'card', [], 'val', []);

for i = 1:numFactors
  [tok, str] = strtok(str);
  numVar = sscanf(tok, '%d');

  F(i).var = zeros(1, numVar);
  F(i).card = zeros(1, numVar);
  
  for j = 1:numVar
    [tok, str] = strtok(str);
    F(i).var(j) = sscanf(tok, '%f');
  end
  
  for j = 1:numVar
    [tok, str] = strtok(str);
    F(i).card(j) = sscanf(tok, '%f');      
  end
  
  [tok, str] = strtok(str);
  nnzX = sscanf(tok, '%d');
        
  % libDAI's .fg format assumes that non-specified entries are zeros.
  % In addition, although the ordering of values is the same as in our 228
  % factor format, the indices start from 0 in the .fg format.
  F(i).val = zeros(1, prod(F(i).card));
  
  for j = 1:nnzX
    [tok, str] = strtok(str);
    idx = sscanf(tok, '%d');
  
    [tok, str] = strtok(str);
    val = sscanf(tok, '%f');
    
    F(i).val(idx + 1) = val;
  end  
end

end

function F = UnserializeFactorsFgMATLAB(str)
%UnserializeFactorsFg Converts a string representing factors in the libDAI
%.fg format into a struct array of factors
% http://cs.ru.nl/~jorism/libDAI/doc/fileformats.html

[numFactors, pos] = textscan(str, '%d', 1);
idx = pos;
numFactors = numFactors{1};



F(numFactors) = struct('var', [], 'card', [], 'val', []);

for i = 1:numFactors
  [numVar, pos] = textscan(str(idx+1:end), '%d', 1);
  idx = idx + pos;  
  numVar = numVar{1};
  
  [var, pos] = textscan(str(idx+1:end), '%f', numVar);
  idx = idx + pos;
  
  [card, pos] = textscan(str(idx+1:end), '%f', numVar);
  idx = idx + pos;
    
  [nnz, pos] = textscan(str(idx+1:end), '%d', 1);
  idx = idx + pos;
  nnz = nnz{1};
  
  [entries, pos] = textscan(str(idx+1:end), '%d %f', nnz);
  idx = idx + pos;
  
  F(i).var = var{:}';
  F(i).card = card{:}';
  
  % libDAI's .fg format assumes that non-specified entries are zeros.
  % In addition, although the ordering of values is the same as in our 228
  % factor format, the indices start from 0 in the .fg format.
  F(i).val = zeros(prod(F(i).card), 1);
  F(i).val(entries{1} + 1) = entries{2};
  F(i).val = F(i).val';
end

end

function f = SortAllFactors(factors)

for i = 1:length(factors)
    factors(i) = SortFactorVars(factors(i));
end

varMat = vertcat(factors(:).var);
[unused, order] = sortrows(varMat);

f = factors(order);

end

function G = SortFactorVars(F)

[sortedVars, order] = sort(F.var);
G.var = sortedVars;

G.card = F.card(order);
G.val = zeros(numel(F.val), 1);

assignmentsInF = IndexToAssignment(1:numel(F.val), F.card);
assignmentsInG = assignmentsInF(:,order);
G.val(AssignmentToIndex(assignmentsInG, G.card)) = F.val;

end


function C = UnserializeTreeFg(str)
%UnserializeFactorsFg Converts a string representing factors in the libDAI
%.fg format into a struct array of factors
% http://cs.ru.nl/~jorism/libDAI/doc/fileformats.html
% Rewritten for Octave compatibility using strtok instead of textscan
% In Octave, double quoted strings allow for escape sequences!

[tok, str] = strtok(str, char(10));
numNodes = sscanf(tok, '%d');

if (~nnz(numNodes))
    [tok, str] = strtok(str, char(10));
    numNodes = sscanf(tok, '%d');
end

C.nodes = cell(1, numNodes);

for i = 1 : numNodes,
  [tok, str] = strtok(str, char(10));
  C.nodes{i} = str2num(tok);
end

[tok, str] = strtok(str, char(10));
numEdges = sscanf(tok, '%d');

if (~nnz(numEdges))
    [tok, str] = strtok(str, char(10));
    numEdges = sscanf(tok, '%d');
end
C.edges = zeros(numEdges, numEdges);

for i = 1 : numEdges,
    [tok, str] = strtok(str, char(10));
    C.edges(i,:) = str2num(tok);
end

C.factorList = UnserializeFactorsFgOctave(str);


end

function C = UnserializeCompactTree(str)
%UnserializeFactorsFg Converts a string representing factors in the libDAI
%.fg format into a struct array of factors
% http://cs.ru.nl/~jorism/libDAI/doc/fileformats.html
% Rewritten for Octave compatibility using strtok instead of textscan
% In Octave, double quoted strings allow for escape sequences!

[tok, str] = strtok(str);
numEdges = sscanf(tok, '%d');

C.edges = zeros(numEdges, numEdges);

for i = 1 : numEdges,
    
    [tok, str] = strtok(str, char(10));
    if (length(tok) == 1)
        % need to re-parse
        [tok, str] = strtok(str, char(10));
    end
    C.edges(i,:) = str2num(tok);
end

C.cliqueList = UnserializeFactorsFgOctave(str);


end
