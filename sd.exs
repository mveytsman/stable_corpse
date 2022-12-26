Mix.install(
  [
    {:kino_bumblebee, "~> 0.1.0"},
    {:exla, "~> 0.4.1"}
  ],
  config: [nx: [default_backend: EXLA.Backend]],
  system_env: %{"XLA_TARGET" => "cuda118", "CUDA_DIR" => "/nix/store/89v9qinlpbv1zglz5rpb781n4b06sq1q-cudatoolkit-11.8.0", "XLA_FLAGS" => "--xla_gpu_cuda_data_dir=/nix/store/89v9qinlpbv1zglz5rpb781n4b06sq1q-cudatoolkit-11.8.0"}
)




{:ok, model_info} = Bumblebee.load_model({:hf, "gpt2"}, log_params_diff: false)
{:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "gpt2"})

serving =
  Bumblebee.Text.generation(model_info, tokenizer,
    max_new_tokens: 10,
    compile: [batch_size: 1, sequence_length: 100],
    defn_options: [compiler: EXLA]
  )



text_input = "Yesterday, I was reading a book and"


Nx.Serving.run(serving, text_input)
|> IO.inspect()
