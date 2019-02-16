% calculate a logic matrix indicating whether a pair of items are neighbors.
function R = calcNeighbor (label, idx1, idx2)
%   N1 = length(idx1);
%   N2 = length(idx2);
%   R = false(N1, N2);
%   T = getConst('MEMORY_CAP');
%   m = floor(T / (8 * N1));
%   p = 1;
%   while p <= N2
%     t = min(p + m - 1, N2);
%     L1 = label(idx1);
%     L2p = label(idx2(p: t));
%     Dp = repmat(L1, 1, length(L2p)) - repmat(L2p', length(L1), 1);
%     R(:, p: t) = Dp == 0;
%     p = p + m;
%   end
if size(label, 2) == 1
  L1 = label(idx1);
  L2 = label(idx2);
  L1 = single(L1);
  L2 = single(L2);
  Dp = repmat(L1,1,length(L2)) - repmat(L2',length(L1),1);
  R = Dp == 0;
elseif size(label, 2) > 1
    L1 = label(idx1, :);
    L2 = label(idx2, :);
    R = L1 * L2' > 0;
end
end
