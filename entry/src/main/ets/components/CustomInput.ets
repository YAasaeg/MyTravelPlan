import Theme from '../utils/Theme';

@Component
export struct CustomInput {
  @Prop placeholder: string;
  @Link text: string;
  @Prop type: InputType = InputType.Normal;
  @Prop icon: ResourceStr | undefined = undefined;

  build() {
    Row() {
      if (this.icon) {
        Image(this.icon)
          .width(20)
          .height(20)
          .margin({ right: Theme.SpacingSmall })
          .fillColor(Theme.ColorTextSecondary)
      }
      TextInput({ placeholder: this.placeholder, text: this.text })
        .type(this.type)
        .placeholderColor(Theme.ColorTextSecondary)
        .fontColor(Theme.ColorTextPrimary)
        .fontSize(16)
        .backgroundColor(Color.Transparent)
        .height('100%')
        .width('100%')
        .onChange((value: string) => {
          this.text = value;
        })
    }
    .width('100%')
    .height(56)
    .padding({ left: Theme.SpacingMedium, right: Theme.SpacingMedium })
    .backgroundColor(Theme.ColorSurface)
    .borderRadius(Theme.RadiusMedium)
    .border({ width: 1, color: Theme.ColorBorder })
  }
}
