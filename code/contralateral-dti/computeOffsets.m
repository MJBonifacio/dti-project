function offsets = computeOffsets(patchCounts)
  offsets = [];
  precedingPatches = 0;

  for i=1:len(patchCounts)
    offsets = [offsets; precedingPatches];
    precedingPatches = precedingPatches + patchCounts(i);
  end
end
