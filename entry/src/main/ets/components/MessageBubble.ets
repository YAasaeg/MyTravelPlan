import Theme from '../utils/Theme';
import { ChatMessage } from '../model/ChatMessage';

@Component
export struct MessageBubble {
  @Prop message: ChatMessage;

  build() {
    Row() {
      if (this.message.role === 'assistant') {
        Circle({ width: 32, height: 32 })
          .fill(Theme.ColorSecondary)
          .margin({ right: Theme.SpacingSmall })
      }

      Column() {
        Text(this.message.content)
          .fontSize(16)
          .fontColor(this.message.role === 'user' ? Theme.ColorSurface : Theme.ColorTextPrimary)
          .lineHeight(24)
      }
      .backgroundColor(this.message.role === 'user' ? Theme.ColorPrimary : Theme.ColorSurface)
      .padding({ 
        top: Theme.SpacingMedium, 
        bottom: Theme.SpacingMedium, 
        left: Theme.SpacingMedium, 
        right: Theme.SpacingMedium 
      })
      .borderRadius({
        topLeft: Theme.RadiusLarge,
        topRight: Theme.RadiusLarge,
        bottomLeft: this.message.role === 'user' ? Theme.RadiusLarge : 0,
        bottomRight: this.message.role === 'user' ? 0 : Theme.RadiusLarge
      })
      .shadow(this.message.role === 'assistant' ? { radius: 10, color: 'rgba(0,0,0,0.05)', offsetY: 2 } : undefined)
      .constraintSize({ maxWidth: '75%' })

      if (this.message.role === 'user') {
        Circle({ width: 32, height: 32 })
          .fill(Theme.ColorPrimary)
          .margin({ left: Theme.SpacingSmall })
      }
    }
    .width('100%')
    .justifyContent(this.message.role === 'user' ? FlexAlign.End : FlexAlign.Start)
    .alignItems(VerticalAlign.Top)
    .margin({ bottom: Theme.SpacingMedium })
  }
}
