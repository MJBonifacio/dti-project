function [sens, spec, acc] = getSensitivitySpecificity2(y, yhat)

tp = nnz((y==1) & (yhat==1));
tn = nnz((y==0) & (yhat==0));
fp = nnz((y==0) & (yhat==1));
fn = nnz((y==1) & (yhat==0));

spec = tn./(tn+fp);
sens = tp./(tp+fn);

acc = (tp + tn) ./ (tp+tn+fp+fn);
