export interface ChatMessage {
  id?: number;
  user_id: number;
  role: 'user' | 'assistant';
  content: string;
  timestamp: number;
}
