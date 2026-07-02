from openai import OpenAI
from app.config import settings

class StyleEngine:
    def __init__(self):
        api_key = getattr(settings, "OPENAI_API_KEY", "").strip()
        
        if not api_key or "mock_key" in api_key:
            self.client = None
            print("⚠️ WARNING: StyleEngine running in OFFLINE fallback mode. Missing API Key.")
        else:
            self.client = OpenAI(api_key=api_key)

    def generate_styled_response(self, user_voice_profile: dict, core_insight: str, query: str) -> str:
        """Takes raw historical insight data and styles it to match the executive's voice profile."""
        if self.client is None:
            return (
                f"[Offline Dev Mode] Style output matching: {user_voice_profile.get('tone')}. "
                f"Core Grounding Data: {core_insight}"
            )
        
        system_prompt = (
            f"You are acting as the live digital twin virtual avatar of an executive.\n"
            f"Your strict communication blueprint is: Tone={user_voice_profile.get('tone')}, "
            f"Formality={user_voice_profile.get('formality')}.\n\n"
            f"Ground your answer ENTIRELY inside this authentic institutional knowledge playbook: {core_insight}\n"
            f"Speak natively in the first person ('I', 'my', 'we') as the executive. Do not break character."
        )

        response = self.client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": query}
            ],
            temperature=0.4
        )
        return response.choices[0].message.content

style_engine = StyleEngine()