import Theme from '../utils/Theme';
import { HomeView } from '../components/HomeView';
import { ChatView } from '../components/ChatView';
import { ProfileView } from '../components/ProfileView';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private controller: TabsController = new TabsController();

  @Builder
  TabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? Theme.ColorPrimary : Theme.ColorTextSecondary)
        .fontSize(this.currentIndex === index ? 16 : 14)
        .fontWeight(this.currentIndex === index ? Theme.FontWeightBold : Theme.FontWeightRegular)
        .animation({ duration: 300 })

      if (this.currentIndex === index) {
        Divider()
          .strokeWidth(2)
          .color(Theme.ColorPrimary)
          .width(20)
          .margin({ top: 4 })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Theme.ColorSurface)
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
      TabContent() {
        HomeView()
      }
      .tabBar(this.TabBuilder(0, '计划'))

      TabContent() {
        ChatView()
      }
      .tabBar(this.TabBuilder(1, '聊天'))

      TabContent() {
        ProfileView()
      }
      .tabBar(this.TabBuilder(2, '个人中心'))
    }
    .vertical(false)
    .barHeight(60)
    .onChange((index: number) => {
      this.currentIndex = index;
    })
    .backgroundColor(Theme.ColorBackground)
  }
}
