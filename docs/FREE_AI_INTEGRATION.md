# FREE AI SERVICES INTEGRATION GUIDE

Complete guide to integrate **completely free AI services** into LEGIMI Commerce.

---

## 🎯 Free AI Options Summary

| Service | Use Case | Free Tier | Setup Time |
|---------|----------|-----------|-----------|
| **Groq** | Fast LLM inference | Unlimited | 2 min |
| **Ollama** | Local LLM (no API key) | Unlimited | 10 min |
| **Hugging Face** | Text + image models | 30k API calls/month | 2 min |
| **Together AI** | LLM inference | $25/month free credits | 2 min |
| **Replicate** | Image generation, ML | $40/month free credits | 2 min |
| **Stability AI** | Image generation | $25 free credits | 5 min |

---

## 1. GROQ API (Recommended - Fastest Free Option)

### Fastest LLM inference available (free, no credit card required initially)

**Setup (2 minutes):**

1. Go to https://console.groq.com/keys
2. Click "Create API Key"
3. Copy the key
4. Add to `.env.local`:
```env
GROQ_API_KEY=gsk_your_key_here
```

**Available Models (Free):**
- `mixtral-8x7b-32768` — Best reasoning, 32K context
- `llama2-70b-4096` — Good for chat, 4K context
- `gemma-7b-it` — Lightweight, instant responses

**Integration Example:**

```typescript
// packages/ai/src/groq.service.ts
import Groq from "groq-sdk";

export class GroqService {
  private client: Groq;

  constructor(apiKey: string) {
    this.client = new Groq({ apiKey });
  }

  async generateStoreDescription(businessType: string): Promise<string> {
    const message = await this.client.messages.create({
      model: "mixtral-8x7b-32768",
      max_tokens: 1024,
      messages: [
        {
          role: "user",
          content: `Generate a compelling store description for a ${businessType} business`,
        },
      ],
    });

    return message.content[0].type === "text" ? message.content[0].text : "";
  }

  async generateProductDescription(
    productName: string,
    category: string
  ): Promise<string> {
    const message = await this.client.messages.create({
      model: "mixtral-8x7b-32768",
      max_tokens: 512,
      messages: [
        {
          role: "user",
          content: `Write a marketing description for ${productName} in ${category} category`,
        },
      ],
    });

    return message.content[0].type === "text" ? message.content[0].text : "";
  }
}
```

**Install:**
```bash
pnpm add groq-sdk
```

---

## 2. OLLAMA (Completely Free - Local LLM)

### Run powerful LLM models locally on your machine (zero cost, no API key needed)

**Setup (10 minutes):**

1. Download from https://ollama.ai
2. Install and run
3. In terminal:
```bash
ollama pull mistral    # Fast model (7B)
# or
ollama pull neural-chat  # Better for chat
```

4. Add to `.env.local`:
```env
OLLAMA_URL=http://localhost:11434
```

**Integration Example:**

```typescript
// packages/ai/src/ollama.service.ts
export class OllamaService {
  constructor(private baseUrl: string = "http://localhost:11434") {}

  async generate(prompt: string): Promise<string> {
    const response = await fetch(`${this.baseUrl}/api/generate`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "mistral",
        prompt,
        stream: false,
      }),
    });

    const data = await response.json();
    return data.response;
  }

  async chat(messages: Array<{ role: string; content: string }>) {
    const response = await fetch(`${this.baseUrl}/api/chat`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "neural-chat",
        messages,
      }),
    });

    const data = await response.json();
    return data.message.content;
  }
}
```

**Advantages:**
- ✅ Completely free (no API costs)
- ✅ Data stays on your machine (privacy)
- ✅ No rate limits
- ✅ Works offline
- ⚠️ Requires local resources (4GB+ RAM recommended)

---

## 3. HUGGING FACE INFERENCE API (Free Tier: 30k calls/month)

### Access thousands of open-source models

**Setup (2 minutes):**

1. Go to https://huggingface.co/settings/tokens
2. Create new token (read)
3. Add to `.env.local`:
```env
HUGGING_FACE_API_KEY=hf_your_token_here
```

**Available Models:**
- Text generation
- Image generation (Stable Diffusion)
- Sentiment analysis
- Translation
- Question answering

**Integration Example:**

```typescript
// packages/ai/src/hugging-face.service.ts
import { HfInference } from "@huggingface/inference";

export class HuggingFaceService {
  private client: HfInference;

  constructor(apiKey: string) {
    this.client = new HfInference(apiKey);
  }

  async generateImage(prompt: string): Promise<Blob> {
    return this.client.textToImage({
      inputs: prompt,
      model: "stabilityai/stable-diffusion-2",
    });
  }

  async generateText(prompt: string): Promise<string> {
    const response = await this.client.textGeneration({
      model: "gpt2",
      inputs: prompt,
      parameters: {
        max_new_tokens: 100,
      },
    });
    return response.generated_text;
  }

  async analyzeText(text: string): Promise<any> {
    return this.client.zeroShotClassification({
      model: "facebook/bart-large-mnli",
      inputs: text,
      parameters: {
        candidate_labels: ["business", "technology", "lifestyle", "fashion"],
      },
    });
  }
}
```

**Install:**
```bash
pnpm add @huggingface/inference
```

---

## 4. TOGETHER AI (Free: $25 monthly credits)

### Fast API inference with various models

**Setup (2 minutes):**

1. Go to https://www.together.ai/
2. Sign up and get API key
3. Add to `.env.local`:
```env
TOGETHER_API_KEY=your_key_here
```

**Integration Example:**

```typescript
// packages/ai/src/together.service.ts
import Together from "together-ai";

export class TogetherService {
  private client: Together;

  constructor(apiKey: string) {
    this.client = new Together({ apiKey });
  }

  async generateText(prompt: string): Promise<string> {
    const response = await this.client.complete({
      model: "mistralai/Mistral-7B-Instruct-v0.1",
      prompt,
      max_tokens: 512,
      temperature: 0.7,
    });

    return response.output.choices[0].text;
  }
}
```

---

## 5. REPLICATE API (Free: $40 monthly credits)

### Image generation, upscaling, and ML models

**Setup (2 minutes):**

1. Go to https://replicate.com/account/api-tokens
2. Create API token
3. Add to `.env.local`:
```env
REPLICATE_API_KEY=r8_your_key_here
```

**Integration Example:**

```typescript
// packages/ai/src/replicate.service.ts
import Replicate from "replicate";

export class ReplicateService {
  private client: Replicate;

  constructor(apiKey: string) {
    this.client = new Replicate({ auth: apiKey });
  }

  async generateProductImage(
    prompt: string
  ): Promise<string> {
    const output = await this.client.run(
      "stability-ai/stable-diffusion:ac732df83cea7fff18b8472768c88ad041fa750ff7682a21aef33d3e3b7bc08f",
      {
        input: {
          prompt,
        },
      }
    );

    return output[0];
  }

  async upscaleImage(imageUrl: string): Promise<string> {
    const output = await this.client.run(
      "nightmareai/real-esrgan:42fed498d7f2dfe47f3b67b4b2a4f79e",
      {
        input: {
          image: imageUrl,
        },
      }
    );

    return output;
  }
}
```

**Install:**
```bash
pnpm add replicate
```

---

## 6. STABILITY AI (Free: $25 credits)

### Best-in-class image generation

**Setup (5 minutes):**

1. Go to https://platform.stability.ai/account/billing/overview
2. Create account and get API key
3. Add to `.env.local`:
```env
STABILITY_API_KEY=sk-your_key_here
```

**Integration Example:**

```typescript
// packages/ai/src/stability.service.ts
export class StabilityService {
  async generateImage(prompt: string): Promise<Buffer> {
    const response = await fetch(
      "https://api.stability.ai/v1/generation/stable-diffusion-v1-6/text-to-image",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
          Authorization: `Bearer ${process.env.STABILITY_API_KEY}`,
        },
        body: JSON.stringify({
          text_prompts: [
            {
              text: prompt,
              weight: 1,
            },
          ],
          cfg_scale: 7,
          height: 512,
          width: 512,
          samples: 1,
          steps: 30,
          sampler: "k_dpmpp_2m",
        }),
      }
    );

    const data = await response.json();
    const imageData = data.artifacts[0].base64;
    return Buffer.from(imageData, "base64");
  }
}
```

---

## RECOMMENDED ARCHITECTURE

### For Store Generation (Completely Free):

```typescript
// apps/api/src/ai/store-generator.service.ts
export class StoreGeneratorService {
  constructor(
    private groq: GroqService,       // Text generation
    private huggingFace: HuggingFaceService, // Images
    private ollama?: OllamaService    // Local backup
  ) {}

  async generateStore(businessDescription: string) {
    // 1. Generate store name and description (Groq - free)
    const storeName = await this.groq.generate(
      `Suggest a catchy store name for: ${businessDescription}`
    );

    // 2. Generate SEO metadata (Groq)
    const seoMetadata = await this.groq.generate(
      `Generate SEO title and description for ${storeName}`
    );

    // 3. Generate product ideas (Groq)
    const products = await this.groq.generate(
      `Suggest 10 products for ${businessDescription}`
    );

    // 4. Generate images (Hugging Face free tier)
    const productImages = await this.huggingFace.generateImage(
      `Professional product image for ${storeName}`
    );

    return {
      storeName,
      seoMetadata,
      products,
      productImages,
    };
  }
}
```

### Cost Analysis:

| Service | Cost | Notes |
|---------|------|-------|
| Groq | FREE | Unlimited, fast |
| Ollama | FREE | Local, unlimited |
| Hugging Face | FREE* | 30k calls/month |
| Stability AI | $0-25 | Free credits monthly |
| Replicate | $0-40 | Free credits monthly |
| **Total** | **FREE** | ✅ Completely free! |

---

## SETUP CHECKLIST

- [ ] Get Groq API key (2 min)
- [ ] Get Hugging Face token (2 min)
- [ ] Get Replicate API key (2 min)
- [ ] (Optional) Download and run Ollama (10 min)
- [ ] Add all keys to `.env.local`
- [ ] Run `pnpm install` for new packages
- [ ] Test AI services in apps/api

---

## USAGE IN YOUR APPLICATION

```typescript
// apps/api/src/ai/ai.module.ts
import { Module } from "@nestjs/common";
import { GroqService } from "@legimi/ai/groq.service";
import { HuggingFaceService } from "@legimi/ai/hugging-face.service";
import { OllamaService } from "@legimi/ai/ollama.service";

@Module({
  providers: [
    {
      provide: "GroqService",
      useValue: new GroqService(process.env.GROQ_API_KEY),
    },
    {
      provide: "HuggingFaceService",
      useValue: new HuggingFaceService(process.env.HUGGING_FACE_API_KEY),
    },
    {
      provide: "OllamaService",
      useValue: new OllamaService(process.env.OLLAMA_URL),
    },
  ],
  exports: ["GroqService", "HuggingFaceService", "OllamaService"],
})
export class AIModule {}
```

---

## NEXT STEPS

1. ✅ Get free API keys (all services)
2. ✅ Add to `.env.local`
3. ✅ Install required packages
4. ✅ Test in development
5. ✅ Deploy to free hosting (Vercel, Railway, Render)

**Total setup time: ~30 minutes**
**Total cost: $0 (forever)**

---

See [SUPABASE_SETUP.md](./SUPABASE_SETUP.md) for database setup and [GITHUB_DEPLOYMENT.md](./GITHUB_DEPLOYMENT.md) for deploying to GitHub and hosting.
