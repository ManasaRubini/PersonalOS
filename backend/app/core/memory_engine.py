import re
import json
import math
from google import genai
from app.config import settings

class MemoryEngine:
    def __init__(self):
        api_key = getattr(settings, "GEMINI_API_KEY", "").strip()
        if not api_key or "mock_key" in api_key:
            self.client = None
            print("⚠️ WARNING: MemoryEngine running in OFFLINE fallback mode.")
        else:
            self.client = genai.Client(api_key=api_key)

    def generate_embedding(self, text: str) -> list[float]:
        """🧬 OPTION B: Generate true mathematical text representations using Gemini"""
        if self.client is None:
            return [0.0] * 768
        try:
            response = self.client.models.embed_content(
                model="text-embedding-004",
                contents=text
            )
            return response.embeddings[0].values
        except Exception:
            return [0.0] * 768

    def calculate_cosine_similarity(self, vec_a: list[float], vec_b: list[float]) -> float:
        """Computes the semantic alignment angle between two embedding profiles."""
        if not vec_a or not vec_b or len(vec_a) != len(vec_b):
            return 0.0
        dot_product = sum(a * b for a, b in zip(vec_a, vec_b))
        norm_a = math.sqrt(sum(a * a for a in vec_a))
        norm_b = math.sqrt(sum(b * b for b in vec_b))
        if norm_a == 0.0 or norm_b == 0.0:
            return 0.0
        return dot_product / (norm_a * norm_b)

    def rank_memories_semantically(self, query_vector: list[float], memories: list, top_k: int = 3) -> list:
        """Ranks database records purely on mathematical conceptual closeness."""
        ranked_memories = []
        for memory in memories:
            if not memory.embedding_vector:
                continue
            
            # Unpack the stored vector string back into a list of floats
            try:
                saved_vector = json.loads(memory.embedding_vector)
                score = self.calculate_cosine_similarity(query_vector, saved_vector)
                ranked_memories.append((memory, score))
            except Exception:
                continue
            
        # Sort descending by similarity score
        ranked_memories.sort(key=lambda x: x[1], reverse=True)
        return [item[0] for item in ranked_memories[:top_k]]

memory_engine = MemoryEngine()