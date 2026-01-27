import Theme from '../utils/Theme';
import { Plan } from '../model/Plan';

@Component
export struct PlanCard {
  @Prop plan: Plan;

  build() {
    Column() {
      Row() {
        Text(this.plan.title)
          .fontSize(18)
          .fontWeight(Theme.FontWeightBold)
          .fontColor(Theme.ColorTextPrimary)
          .layoutWeight(1)
        
        Text(this.plan.date)
          .fontSize(12)
          .fontColor(Theme.ColorAccent)
          .backgroundColor('#F0F4F8')
          .padding({ top: 4, bottom: 4, left: 8, right: 8 })
          .borderRadius(4)
      }
      .width('100%')
      .margin({ bottom: Theme.SpacingMedium })

      Text(this.plan.content)
        .fontSize(15)
        .fontColor(Theme.ColorTextSecondary)
        .lineHeight(24)
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .padding(Theme.SpacingLarge)
    .backgroundColor(Theme.ColorSurface)
    .borderRadius(Theme.RadiusLarge)
    .shadow({ radius: 20, color: 'rgba(0,0,0,0.05)', offsetY: 8 })
    .margin({ bottom: Theme.SpacingMedium })
  }
}
