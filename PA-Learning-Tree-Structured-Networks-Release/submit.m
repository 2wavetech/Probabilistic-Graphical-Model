function submit(part)
  addpath('./lib');

  conf.assignmentKey = 'ZtTFjgNhEeahzAr11F1cUw';
  conf.itemName = 'Learning Tree-structured Networks';

  conf.partArrays = { ...
    { ...
      'ZWTe6', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'MHKM2', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'ersuQ', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'bzqOa', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      '7vCzT', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'N3abb', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'YMrzB', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'loxgM', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'izsvG', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'xWOCw', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'pBr7I', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'a7bhx', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      '22gxv', ...
      { '' }, ...
      '', ...
    }, ...
    { ...
      'Bd2ZE', ...
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

  if partId == 1
    load 'PA8SampleCases.mat';
    [i j] = FitGaussianParameters(exampleINPUT.t1a1);
    out = [SerializeFloat(i) ' ' SerializeFloat(j) ' '];
    
  elseif partId == 2
    load 'submit_input.mat';
    [i j] = FitGaussianParameters(INPUT.t1a1);
    out = [SerializeFloat(i) ' ' SerializeFloat(j) ' '];
    clear 'INPUT';

  elseif partId == 3

    load 'PA8SampleCases.mat';
    [i j] = FitLinearGaussianParameters(exampleINPUT.t2a1, exampleINPUT.t2a2);
    out = '';
    for idx = 1:length(i)
        out = [out ' ' SerializeFloat(i(idx))];
    end
    out = [out ' ' num2str(j)];
  elseif partId == 4

    load 'submit_input.mat';
    [i j] = FitLinearGaussianParameters(INPUT.t2a1, INPUT.t2a2);
    out = '';
    for idx = 1:length(i)
        out = [out ' ' SerializeFloat(i(idx))];
    end
    out = [out ' ' num2str(j)];
    clear 'INPUT';

  elseif partId == 5

    load 'PA8SampleCases.mat';
    i = ComputeLogLikelihood(exampleINPUT.t3a1, exampleINPUT.t3a2, exampleINPUT.t3a3); 
    out = SerializeFloat(i);
    
  elseif partId == 6

    load 'submit_input.mat';
    i = ComputeLogLikelihood(INPUT.t3a1, INPUT.t3a2, INPUT.t3a3); 
    out = SerializeFloat(i);
    clear 'INPUT';
    
  elseif partId == 7
      
    load 'PA8SampleCases.mat';
    [P L] = LearnCPDsGivenGraph(exampleINPUT.t4a1, exampleINPUT.t4a2, exampleINPUT.t4a3);
    tmp = [[P.c] [P.clg.sigma_x] [P.clg.sigma_y] [P.clg.sigma_angle]];
    out = '';
    for idx = 1:length(tmp)
        out = [out ' ' SerializeFloat(tmp(idx))];
    end
    out = [out ' ' SerializeFloat(L)];

  elseif partId == 8

    load 'submit_input.mat';
    [P L] = LearnCPDsGivenGraph(INPUT.t4a1, INPUT.t4a2, INPUT.t4a3);
    tmp = [[P.c] [P.clg.sigma_x] [P.clg.sigma_y] [P.clg.sigma_angle]];
    out = '';
    for idx = 1:length(tmp)
        out = [out ' ' SerializeFloat(tmp(idx))];
    end
    out = [out ' ' SerializeFloat(L)];
    clear 'INPUT';
    
  elseif partId == 9
    load 'PA8SampleCases.mat';
    i = ClassifyDataset(exampleINPUT.t5a1, exampleINPUT.t5a2, exampleINPUT.t5a3, exampleINPUT.t5a4);   
    out = SerializeFloat(i);
    
  elseif partId == 10

    load 'submit_input.mat';
    i = ClassifyDataset(INPUT.t5a1, INPUT.t5a2, INPUT.t5a3, INPUT.t5a4);   
    out = SerializeFloat(i);
    clear 'INPUT';
    
  elseif partId == 11
    load 'PA8SampleCases.mat';
    [A W] = LearnGraphStructure(exampleINPUT.t6a1);
    out = '';
    for idx = 1:numel(A)
        out = [out ' ' num2str(A(idx))];
    end
  elseif partId == 12
    load 'submit_input.mat';
    [A W] = LearnGraphStructure(INPUT.t6a1);
    out = '';
    for idx = 1:numel(A)
        out = [out ' ' num2str(A(idx))];
    end
    clear 'INPUT';
    
  elseif partId == 13
    load 'PA8SampleCases.mat';
    [P G L] = LearnGraphAndCPDs(exampleINPUT.t7a1, exampleINPUT.t7a2);
    tmp = [[P.c] [P.clg.sigma_x] [P.clg.sigma_y] [P.clg.sigma_angle]];
    out = '';
    for idx = 1:numel(tmp)
        out = [out ' ' SerializeFloat(tmp(idx))];
    end
    for idx = 1:numel(G)
        out = [out ' ' SerializeFloat(G(idx))];
    end
    out = [out ' ' SerializeFloat(L)]; 
  elseif partId == 14
    load 'submit_input.mat';
    [P G L] = LearnGraphAndCPDs(INPUT.t7a1, INPUT.t7a2);
    tmp = [[P.c] [P.clg.sigma_x] [P.clg.sigma_y] [P.clg.sigma_angle]];
    out = '';
    for idx = 1:length(tmp)
        out = [out ' ' SerializeFloat(tmp(idx))];
    end
    for idx = 1:numel(G)
        out = [out ' ' SerializeFloat(G(idx))];
    end
    out = [out ' ' SerializeFloat(L)];
    clear 'INPUT';
  end
  
  % end of output function.
  out = strtrim(out);

end


function out = SerializeFloat( x )
  out = sprintf('%.4f', x);
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



