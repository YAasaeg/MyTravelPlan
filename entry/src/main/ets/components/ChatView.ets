import Theme from '../utils/Theme';
import { ChatMessage } from '../model/ChatMessage';
import { DatabaseManager } from '../db/DatabaseManager';
import { MessageBubble } from './MessageBubble';
import { DeepSeekService } from '../utils/DeepSeekService';
import { User } from '../model/User';

@Component
export struct ChatView {
  @State messages: ChatMessage[] = [];
  @State inputText: string = '';
  @StorageLink('currentUser') currentUser: User = { username: '' };
  scroller: Scroller = new Scroller();

  async aboutToAppear() {
    await this.loadHistory();
  }

  async loadHistory() {
    if (this.currentUser && this.currentUser.id) {
      const db = DatabaseManager.getInstance();
      this.messages = await db.getChatHistory(this.currentUser.id);
      this.scrollToBottom();
    }
  }

  scrollToBottom() {
    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 100);
  }

  async sendMessage() {
    if (!this.inputText.trim() || !this.currentUser.id) return;

    const userMsg: ChatMessage = {
      user_id: this.currentUser.id,
      role: 'user',
      content: this.inputText,
      timestamp: Date.now()
    };

    // 更新对话
    this.messages = [...this.messages, userMsg];
    const db = DatabaseManager.getInstance();
    await db.addChatMessage(userMsg);

    const prompt = this.inputText;
    this.inputText = '';
    this.scrollToBottom();

    try {
      // 发起对话
      const response: string = await DeepSeekService.sendMessage(prompt);

      const aiMsg: ChatMessage = {
        user_id: this.currentUser.id,
        role: 'assistant',
        content: response,
        timestamp: Date.now()
      };

      // 更新回答
      this.messages = [...this.messages, aiMsg];
      await db.addChatMessage(aiMsg);
      this.scrollToBottom();
    } catch (err) {
      console.error('Chat Error:', JSON.stringify(err));
    }
  }

  build() {
    Column() {
      //顶部样式
      Text('智能旅行助手')
        .fontSize(18)
        .fontWeight(Theme.FontWeightMedium)
        .fontColor(Theme.ColorPrimary)
        .padding({ top: Theme.SpacingMedium, bottom: Theme.SpacingMedium })
        .backgroundColor(Theme.ColorSurface)
        .width('100%')
        .textAlign(TextAlign.Center)
        .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 1 })

      // 聊天区域
      List({ scroller: this.scroller, space: Theme.SpacingSmall }) {
        ForEach(this.messages, (msg: ChatMessage) => {
          ListItem() {
            MessageBubble({ message: msg })
          }
        })
      }
      .layoutWeight(1)
      .width('100%')
      .padding({ left: Theme.SpacingMedium, right: Theme.SpacingMedium, top: Theme.SpacingMedium })

      // 输入区域
      Row() {
        TextInput({ text: this.inputText, placeholder: '请输入提问...' })
          .layoutWeight(1)
          .height(48)
          .backgroundColor('#F0F2F5')
          .borderRadius(24)
          .padding({ left: Theme.SpacingMedium, right: Theme.SpacingMedium })
          .onChange((value) => {
            this.inputText = value;
          })
          .onSubmit(() => {
            this.sendMessage();
          })

        Button() {
          Text('➤')
            .fontColor(Theme.ColorSurface)
            .fontSize(18)
        }
        .width(48)
        .height(48)
        .borderRadius(24)
        .backgroundColor(Theme.ColorPrimary)
        .margin({ left: Theme.SpacingSmall })
        .onClick(() => {
          this.sendMessage();
        })
      }
      .width('100%')
      .padding(Theme.SpacingMedium)
      .backgroundColor(Theme.ColorSurface)
      .border({ width: { top: 1 }, color: Theme.ColorBorder })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.ColorBackground)
  }
}
