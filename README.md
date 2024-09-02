# LLM 验证器

## 使用

直接下载预编译版本，运行按照提示输入 API 信息即可。若不信任预编译版本，也可下载 [Racket](https://racket-lang.org/) 运行 `main.rkt`。

注意，预生成的参考文本仅支持如下模型识别

- gpt-4o
- gpt-4o-mini
- claude-3-5-sonnet
- deepseek-chat
- deepseek-coder
- gemini-1.5-pro-001
- gemini-1.5-flash-001
- claude-3-haiku
- claude-3-sonnet
- claude-3-opus
- gemini-1.5-pro-exp-0827
- gemini-1.5-flash-exp-0827

## 功能

给定一个 OpenAI 兼容 API 和模型名称，检查其最接近的实际模型。

## 原理

计算和参考回复之间的[编辑距离](https://en.wikipedia.org/wiki/Levenshtein_distance)并排序。

参考回复是用 `pre-collect.rkt` 生成，并保存在 `pre-result.data` 中的，生成参考回复时，需将参考 API 信息填写在 `api-data.rkt` 中。

## 准确性

还行，但没有任何保证。也有时候会出错。

## 局限性

没有错误处理
