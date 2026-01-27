import Theme from '../utils/Theme';
import { Plan } from '../model/Plan';
import { DatabaseManager } from '../db/DatabaseManager';
import { PlanCard } from './PlanCard';
import { CustomButton } from './CustomButton';
import { CustomInput } from './CustomInput';
import { User } from '../model/User';
import promptAction from '@ohos.promptAction';
import { router } from '@kit.ArkUI';

@Component
export struct HomeView {
  @State plans: Plan[] = [];
  @StorageLink('currentUser') currentUser: User = { username: '' };

  // 添加计划
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AddPlanDialog({
      confirm: (title: string, content: string): Promise<void> => this.addPlan(title, content)
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: true
  });

  async aboutToAppear() {
    await this.loadPlans();
  }

  async loadPlans() {
    if (this.currentUser && this.currentUser.id) {
      const db = DatabaseManager.getInstance();
      this.plans = await db.getPlans(this.currentUser.id);
    }
  }

  async addPlan(title: string, content: string) {
    if (this.currentUser && this.currentUser.id) {
      const db = DatabaseManager.getInstance();
      const newPlan: Plan = {
        user_id: this.currentUser.id,
        title: title,
        content: content,
        date: new Date().toISOString().split('T')[0]
      };
      await db.addPlan(newPlan);
      await this.loadPlans();
    }
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        Text('我的旅游计划')
          .fontSize(24)
          .fontWeight(Theme.FontWeightBold)
          .fontColor(Theme.ColorPrimary)
          .width('100%')
          .margin({ top: Theme.SpacingLarge, bottom: Theme.SpacingLarge })
          .padding({ left: Theme.SpacingMedium })

        List({ space: Theme.SpacingMedium }) {
          ForEach(this.plans, (item: Plan) => {
            ListItem() {
              PlanCard({ plan: item })
            }.onClick(()=>{
              router.push({
                url:'components/PlanDetail',
                params: { id: item.id }
              })
            })
          })
        }
        .width('100%')
        .height('100%')
        .padding({ left: Theme.SpacingMedium, right: Theme.SpacingMedium, bottom: 80 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Theme.ColorBackground)

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Text('+')
          .fontSize(30)
          .fontColor(Theme.ColorSurface)
          .fontWeight(Theme.FontWeightLight)
      }
      .width(60)
      .height(60)
      .backgroundColor(Theme.ColorPrimary)
      .shadow({ radius: 10, color: 'rgba(0,0,0,0.2)', offsetY: 5 })
      .margin({ right: Theme.SpacingLarge, bottom: Theme.SpacingLarge })
      .onClick(() => {
        this.dialogController.open();
      })
    }
    .width('100%')
    .height('100%')
  }
}

@CustomDialog
struct AddPlanDialog {
  controller: CustomDialogController;
  confirm: (title: string, content: string) => void = () => {};
  @State title: string = '';
  @State content: string = '';

  build() {
    Column() {
      Text('新建计划')
        .fontSize(20)
        .fontWeight(Theme.FontWeightBold)
        .margin({ bottom: Theme.SpacingLarge })

      CustomInput({ placeholder: '目的地 / 标题', text: $title })
        .margin({ bottom: Theme.SpacingMedium })

      // 计划详情
      TextArea({ placeholder: '详情', text: this.content })
        .height(140)
        .fontSize(16)
        .placeholderColor(Theme.ColorTextSecondary)
        .fontColor(Theme.ColorTextPrimary)
        .backgroundColor(Theme.ColorSurface)
        .padding(Theme.SpacingMedium)
        .borderRadius(Theme.RadiusMedium)
        .border({ width: 1, color: Theme.ColorBorder })
        .onChange((value: string) => {
          this.content = value;
        })
        .margin({ bottom: Theme.SpacingLarge })


      CustomButton({
        text: '保存计划',
        onClickAction: () => {
          if (this.title && this.content) {
            this.confirm(this.title, this.content);
            this.controller.close();
          } else {
            promptAction.showToast({ message: '请填写所有内容' });
          }
        }
      })
    }
    .backgroundColor(Theme.ColorSurface)
    .padding(Theme.SpacingLarge)
    .borderRadius({ topLeft: Theme.RadiusLarge, topRight: Theme.RadiusLarge })
    .width('100%')
  }
}
