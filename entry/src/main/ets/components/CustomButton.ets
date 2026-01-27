import Theme from '../utils/Theme';

@Component
export struct CustomButton {
  @Prop text: string;
  onClickAction: () => void = () => {};
  @Prop widthVal: Length = '100%';
  @Prop heightVal: Length = 50;
  @Prop bgColor: string = Theme.ColorPrimary;
  @Prop textColor: string = Theme.ColorSurface;

  build() {
    Button(this.text)
      .width(this.widthVal)
      .height(this.heightVal)
      .backgroundColor(this.bgColor)
      .fontColor(this.textColor)
      .fontSize(16)
      .fontWeight(Theme.FontWeightMedium)
      .borderRadius(Theme.RadiusMedium)
      .shadow({ radius: 12, color: 'rgba(0,0,0,0.1)', offsetY: 4 })
      .onClick(() => {
        if (this.onClickAction) {
          this.onClickAction();
        }
      })
  }
}
