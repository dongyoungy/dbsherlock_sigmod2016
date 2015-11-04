function clearCausalModels(path)
    model_files = [path '/causal_models/*.mat'];
    delete(model_files);
end