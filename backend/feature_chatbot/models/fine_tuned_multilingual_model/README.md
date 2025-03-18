---
tags:
- sentence-transformers
- sentence-similarity
- feature-extraction
- generated_from_trainer
- dataset_size:5099
- loss:MultipleNegativesRankingLoss
base_model: sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2
widget:
- source_sentence: පාංශු සෞඛ්‍යය වැඩි දියුණු කිරීම සඳහා වී ගොවිතැනේදී ආවරණ බෝග භාවිතා
    කිරීම සඳහා වන රෙගුලාසි මොනවාද?
  sentences:
  - නියඟයෙන් වී වගාවන්ට ඇති වන බලපෑම ගොවීන් කළමනාකරණය කරන්නේ කෙසේද?
  - ආවරණ බෝග තෝරා ගැනීම සහ කළමනාකරණය කිරීම සඳහා කෘෂිකාර්මික බලධාරීන්ගේ මාර්ගෝපදේශ
    අනුගමනය කිරීම සහ පාංශු සංරක්ෂණ පිළිවෙත්වලට අනුකූල වීම සහතික කිරීම.
  - මධ්‍යවර්ත උෂ්ණත්වය පවත්වා ගැනීම, ස්වයංක්‍රිය ජල සෙන්සර් භාවිතය, සෙවණ ලබා දීම,
    අධික උෂ්ණත්වයක් පහළ කළ හැකි ක්‍රියා.
- source_sentence: වී ගොවිතැන සඳහා පරිසර හිතකාමී පළිබෝධ පාලන ක්‍රම භාවිතා කිරීමේ ප්‍රතිලාභ
    මොනවාද?
  sentences:
  - වී විකාශය අවධිවීමේ අඩු වීම, ශාක විනාශය, අස්වැන්න ඉතා අඩු වීම.
  - ගොවි ණය සහන ලබාගන්න ණය ලබාගත් බැංකුවට යන්න. ඒ වගේම, කෘෂිකර්ම දෙපාර්තමේන්තුවෙන්
    ගොවි ණය සහන යෝජනා ක්‍රම ගැන විමසන්න.
  - පරිසර හිතකාමී ක්‍රම මගින් පාරිසරික බලපෑම අවම කිරීම සහ හිතකර ජීවීන් ආරක්ෂා කිරීම,
    තිරසාර සහ වගකීම් සහිත පළිබෝධ කළමනාකරණයට සහාය වීම.
- source_sentence: අපේ ගොවි ගමේ ගොවි කෞතුකාගාරයක් හදලා දෙන්න රජයෙන් බැරිද?
  sentences:
  - වී පැළ සිටුවීමේදී පැළ අතර නිසි පරතරයක් තබා සිටුවිය යුතුය. එසේම, පැළ සිටුවීමෙන්
    පසු හොඳින් ජලය සැපයිය යුතුය.
  - නියඟය, ගංවතුර, ලවණතාවය, අධික උෂ්ණත්වය, අඩු උෂ්ණත්වය.
  - අපේ ගොවි ගමේ ගොවි කෞතුකාගාරයක් හදලා දෙන්න රජයෙන් පුළුවන් නම් අපේ ගොවිතැන් ඉතිහාසය
    ආරක්ෂා කරගන්න පුළුවන්.
- source_sentence: වී වගාවෙදී පළිබෝධ නාශක රසායනික භාවිතය අඩු කිරීමේ ප්‍රධාන උදාන මොනවාද?
  sentences:
  - දිරාපත් වූ කාබනික පොහොර.
  - බීජ ඉනසිටීම මන්දගාමී වීම, ශාක වර්ධනය දීර්ඝ සමය ගත වීම, අස්වැන්න ප්‍රමාණය අඩුවීම.
  - රාජ්‍ය නීති, පාරිසරික සම්බන්ධතා, සෞඛ්‍ය සුරක්ෂිතභාවය, පරිසර ප්‍රතිචාර.
- source_sentence: වගා කළ ඉඩමේ pH අංශක අනුව පොහොර යෙදීම වෙනස් වේද?
  sentences:
  - ඔව්, pH අනුව වෙතින් ෆොස්ෆේට් හා අනෙකුත් සන්ධාන ගැලපුම වෙනස් වන බැවින් සකස් කළ
    යුතුය.
  - ප්‍රතිරෝධී ප්‍රභේද භාවිතා කිරීම, සුදුසු බැක්ටීරියා නාශක යෙදීම සහ ජල මට්ටම කළමනාකරණය
    කිරීම භාවිතයන් අතර වේ.
  - ඒක ගොවිවැසියන්ට තීරණ ගන්න පහසුකම් සපයන නිසා, වර්ධන වේලාව, රෝග අවදානම්, වෙළෙඳපොළ
    මිල වැනි කරුණු සලකා බැලිය හැක.
pipeline_tag: sentence-similarity
library_name: sentence-transformers
---

# SentenceTransformer based on sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2

This is a [sentence-transformers](https://www.SBERT.net) model finetuned from [sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2](https://huggingface.co/sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2). It maps sentences & paragraphs to a 384-dimensional dense vector space and can be used for semantic textual similarity, semantic search, paraphrase mining, text classification, clustering, and more.

## Model Details

### Model Description
- **Model Type:** Sentence Transformer
- **Base model:** [sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2](https://huggingface.co/sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2) <!-- at revision 86741b4e3f5cb7765a600d3a3d55a0f6a6cb443d -->
- **Maximum Sequence Length:** 128 tokens
- **Output Dimensionality:** 384 dimensions
- **Similarity Function:** Cosine Similarity
<!-- - **Training Dataset:** Unknown -->
<!-- - **Language:** Unknown -->
<!-- - **License:** Unknown -->

### Model Sources

- **Documentation:** [Sentence Transformers Documentation](https://sbert.net)
- **Repository:** [Sentence Transformers on GitHub](https://github.com/UKPLab/sentence-transformers)
- **Hugging Face:** [Sentence Transformers on Hugging Face](https://huggingface.co/models?library=sentence-transformers)

### Full Model Architecture

```
SentenceTransformer(
  (0): Transformer({'max_seq_length': 128, 'do_lower_case': False}) with Transformer model: BertModel 
  (1): Pooling({'word_embedding_dimension': 384, 'pooling_mode_cls_token': False, 'pooling_mode_mean_tokens': True, 'pooling_mode_max_tokens': False, 'pooling_mode_mean_sqrt_len_tokens': False, 'pooling_mode_weightedmean_tokens': False, 'pooling_mode_lasttoken': False, 'include_prompt': True})
)
```

## Usage

### Direct Usage (Sentence Transformers)

First install the Sentence Transformers library:

```bash
pip install -U sentence-transformers
```

Then you can load this model and run inference.
```python
from sentence_transformers import SentenceTransformer

# Download from the 🤗 Hub
model = SentenceTransformer("sentence_transformers_model_id")
# Run inference
sentences = [
    'වගා කළ ඉඩමේ pH අංශක අනුව පොහොර යෙදීම වෙනස් වේද?',
    'ඔව්, pH අනුව වෙතින් ෆොස්ෆේට් හා අනෙකුත් සන්ධාන ගැලපුම වෙනස් වන බැවින් සකස් කළ යුතුය.',
    'ඒක ගොවිවැසියන්ට තීරණ ගන්න පහසුකම් සපයන නිසා, වර්ධන වේලාව, රෝග අවදානම්, වෙළෙඳපොළ මිල වැනි කරුණු සලකා බැලිය හැක.',
]
embeddings = model.encode(sentences)
print(embeddings.shape)
# [3, 384]

# Get the similarity scores for the embeddings
similarities = model.similarity(embeddings, embeddings)
print(similarities.shape)
# [3, 3]
```

<!--
### Direct Usage (Transformers)

<details><summary>Click to see the direct usage in Transformers</summary>

</details>
-->

<!--
### Downstream Usage (Sentence Transformers)

You can finetune this model on your own dataset.

<details><summary>Click to expand</summary>

</details>
-->

<!--
### Out-of-Scope Use

*List how the model may foreseeably be misused and address what users ought not to do with the model.*
-->

<!--
## Bias, Risks and Limitations

*What are the known or foreseeable issues stemming from this model? You could also flag here known failure cases or weaknesses of the model.*
-->

<!--
### Recommendations

*What are recommendations with respect to the foreseeable issues? For example, filtering explicit content.*
-->

## Training Details

### Training Dataset

#### Unnamed Dataset

* Size: 5,099 training samples
* Columns: <code>sentence_0</code>, <code>sentence_1</code>, and <code>label</code>
* Approximate statistics based on the first 1000 samples:
  |         | sentence_0                                                                       | sentence_1                                                                         | label                                                         |
  |:--------|:---------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------|:--------------------------------------------------------------|
  | type    | string                                                                           | string                                                                             | float                                                         |
  | details | <ul><li>min: 7 tokens</li><li>mean: 21.7 tokens</li><li>max: 43 tokens</li></ul> | <ul><li>min: 3 tokens</li><li>mean: 37.72 tokens</li><li>max: 128 tokens</li></ul> | <ul><li>min: 1.0</li><li>mean: 1.0</li><li>max: 1.0</li></ul> |
* Samples:
  | sentence_0                                                                       | sentence_1                                                                                                                                                                                                       | label            |
  |:---------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------|
  | <code>සහල් බැක්ටීරියා අංගමාරය පාලනය කිරීම සඳහා නිර්දේශිත පිළිවෙත් මොනවාද?</code> | <code>ප්‍රතිරෝධී ප්‍රභේද භාවිතා කිරීම, සුදුසු බැක්ටීරියා නාශක යෙදීම සහ ජල මට්ටම කළමනාකරණය කිරීම භාවිතයන් අතර වේ.</code>                                                                                          | <code>1.0</code> |
  | <code>මගේ කුඹුරේ ගොයම් ගස්වල කොළවල සුදු පාට ලප තියෙනවා. මොකද හේතුව?</code>       | <code>ගොයම් ගස්වල කොළවල සුදු පාට ලප තියෙනවා නම්, ඒක රෝගයක් වෙන්න පුළුවන්. ගොයම් පුස් රෝගය වගේ රෝග නිසා කොළවල සුදු පාට ලප ඇති වෙනවා. කෘෂිකර්ම නිලධාරියෙක්ගෙන් උපදෙස් අරගෙන සුදුසු දිලීර නාශක භාවිතා කරන්න.</code> | <code>1.0</code> |
  | <code>වී වගාවෙදී ලැබෙන වේලූ අපද්‍රව්‍ය භාවිතය කළ හැකි ක්‍රම මොනවාද?</code>       | <code>කොම්පෝස්ට් සකස් කිරීම, ජීව පොහොර ලැබීම, මැලිය උපදවීම, පස උපයෝගීතා වැඩිදියුණු කිරීම.</code>                                                                                                                 | <code>1.0</code> |
* Loss: [<code>MultipleNegativesRankingLoss</code>](https://sbert.net/docs/package_reference/sentence_transformer/losses.html#multiplenegativesrankingloss) with these parameters:
  ```json
  {
      "scale": 20.0,
      "similarity_fct": "cos_sim"
  }
  ```

### Training Hyperparameters
#### Non-Default Hyperparameters

- `per_device_train_batch_size`: 32
- `per_device_eval_batch_size`: 32
- `num_train_epochs`: 1
- `multi_dataset_batch_sampler`: round_robin

#### All Hyperparameters
<details><summary>Click to expand</summary>

- `overwrite_output_dir`: False
- `do_predict`: False
- `eval_strategy`: no
- `prediction_loss_only`: True
- `per_device_train_batch_size`: 32
- `per_device_eval_batch_size`: 32
- `per_gpu_train_batch_size`: None
- `per_gpu_eval_batch_size`: None
- `gradient_accumulation_steps`: 1
- `eval_accumulation_steps`: None
- `torch_empty_cache_steps`: None
- `learning_rate`: 5e-05
- `weight_decay`: 0.0
- `adam_beta1`: 0.9
- `adam_beta2`: 0.999
- `adam_epsilon`: 1e-08
- `max_grad_norm`: 1
- `num_train_epochs`: 1
- `max_steps`: -1
- `lr_scheduler_type`: linear
- `lr_scheduler_kwargs`: {}
- `warmup_ratio`: 0.0
- `warmup_steps`: 0
- `log_level`: passive
- `log_level_replica`: warning
- `log_on_each_node`: True
- `logging_nan_inf_filter`: True
- `save_safetensors`: True
- `save_on_each_node`: False
- `save_only_model`: False
- `restore_callback_states_from_checkpoint`: False
- `no_cuda`: False
- `use_cpu`: False
- `use_mps_device`: False
- `seed`: 42
- `data_seed`: None
- `jit_mode_eval`: False
- `use_ipex`: False
- `bf16`: False
- `fp16`: False
- `fp16_opt_level`: O1
- `half_precision_backend`: auto
- `bf16_full_eval`: False
- `fp16_full_eval`: False
- `tf32`: None
- `local_rank`: 0
- `ddp_backend`: None
- `tpu_num_cores`: None
- `tpu_metrics_debug`: False
- `debug`: []
- `dataloader_drop_last`: False
- `dataloader_num_workers`: 0
- `dataloader_prefetch_factor`: None
- `past_index`: -1
- `disable_tqdm`: False
- `remove_unused_columns`: True
- `label_names`: None
- `load_best_model_at_end`: False
- `ignore_data_skip`: False
- `fsdp`: []
- `fsdp_min_num_params`: 0
- `fsdp_config`: {'min_num_params': 0, 'xla': False, 'xla_fsdp_v2': False, 'xla_fsdp_grad_ckpt': False}
- `fsdp_transformer_layer_cls_to_wrap`: None
- `accelerator_config`: {'split_batches': False, 'dispatch_batches': None, 'even_batches': True, 'use_seedable_sampler': True, 'non_blocking': False, 'gradient_accumulation_kwargs': None}
- `deepspeed`: None
- `label_smoothing_factor`: 0.0
- `optim`: adamw_torch
- `optim_args`: None
- `adafactor`: False
- `group_by_length`: False
- `length_column_name`: length
- `ddp_find_unused_parameters`: None
- `ddp_bucket_cap_mb`: None
- `ddp_broadcast_buffers`: False
- `dataloader_pin_memory`: True
- `dataloader_persistent_workers`: False
- `skip_memory_metrics`: True
- `use_legacy_prediction_loop`: False
- `push_to_hub`: False
- `resume_from_checkpoint`: None
- `hub_model_id`: None
- `hub_strategy`: every_save
- `hub_private_repo`: None
- `hub_always_push`: False
- `gradient_checkpointing`: False
- `gradient_checkpointing_kwargs`: None
- `include_inputs_for_metrics`: False
- `include_for_metrics`: []
- `eval_do_concat_batches`: True
- `fp16_backend`: auto
- `push_to_hub_model_id`: None
- `push_to_hub_organization`: None
- `mp_parameters`: 
- `auto_find_batch_size`: False
- `full_determinism`: False
- `torchdynamo`: None
- `ray_scope`: last
- `ddp_timeout`: 1800
- `torch_compile`: False
- `torch_compile_backend`: None
- `torch_compile_mode`: None
- `dispatch_batches`: None
- `split_batches`: None
- `include_tokens_per_second`: False
- `include_num_input_tokens_seen`: False
- `neftune_noise_alpha`: None
- `optim_target_modules`: None
- `batch_eval_metrics`: False
- `eval_on_start`: False
- `use_liger_kernel`: False
- `eval_use_gather_object`: False
- `average_tokens_across_devices`: False
- `prompts`: None
- `batch_sampler`: batch_sampler
- `multi_dataset_batch_sampler`: round_robin

</details>

### Framework Versions
- Python: 3.13.1
- Sentence Transformers: 3.4.1
- Transformers: 4.49.0
- PyTorch: 2.6.0+cpu
- Accelerate: 1.5.1
- Datasets: 3.3.2
- Tokenizers: 0.21.1

## Citation

### BibTeX

#### Sentence Transformers
```bibtex
@inproceedings{reimers-2019-sentence-bert,
    title = "Sentence-BERT: Sentence Embeddings using Siamese BERT-Networks",
    author = "Reimers, Nils and Gurevych, Iryna",
    booktitle = "Proceedings of the 2019 Conference on Empirical Methods in Natural Language Processing",
    month = "11",
    year = "2019",
    publisher = "Association for Computational Linguistics",
    url = "https://arxiv.org/abs/1908.10084",
}
```

#### MultipleNegativesRankingLoss
```bibtex
@misc{henderson2017efficient,
    title={Efficient Natural Language Response Suggestion for Smart Reply},
    author={Matthew Henderson and Rami Al-Rfou and Brian Strope and Yun-hsuan Sung and Laszlo Lukacs and Ruiqi Guo and Sanjiv Kumar and Balint Miklos and Ray Kurzweil},
    year={2017},
    eprint={1705.00652},
    archivePrefix={arXiv},
    primaryClass={cs.CL}
}
```

<!--
## Glossary

*Clearly define terms in order to be accessible across audiences.*
-->

<!--
## Model Card Authors

*Lists the people who create the model card, providing recognition and accountability for the detailed work that goes into its construction.*
-->

<!--
## Model Card Contact

*Provides a way for people who have updates to the Model Card, suggestions, or questions, to contact the Model Card authors.*
-->