import Theme from '../utils/Theme';
import router from '@ohos.router';
import { DatabaseManager } from '../db/DatabaseManager';
import { Plan } from '../model/Plan';
import promptAction from '@ohos.promptAction';

interface id {
  id?: number | string;
}

@Entry
@Component
export struct PlanDetail {
  @State plan: Plan | null = null;
  @State editMode: boolean = true;
  @State tempTitle: string = '';
  @State tempContent: string = '';

  async aboutToAppear() {
    const params = router.getParams() as id;
    const idRaw = params?.id;
    const id = typeof idRaw === 'string' ? Number(idRaw) : idRaw;
    if (typeof id === 'number' && !Number.isNaN(id)) {
      const db: DatabaseManager = DatabaseManager.getInstance();
      this.plan = await db.getPlanById(id);
      if (this.plan) {
        this.tempTitle = this.plan.title;
        this.tempContent = this.plan.content;
      }
    }
  }

  async savePlan() {
    if (!this.plan || !this.plan.id) return;
    const db: DatabaseManager = DatabaseManager.getInstance();
    const updated: Plan = {
      id: this.plan.id,
      user_id: this.plan.user_id,
      title: this.tempTitle,
      content: this.tempContent,
      date: this.plan.date
    };
    const res = await db.updatePlan(updated);
    if (res >= 0) {
      this.plan = updated;
      promptAction.showToast({
        message: '保存成功'
      });
    }
  }

  private isDirty(): boolean {
    if (!this.plan) return false;
    return this.tempTitle !== this.plan.title || this.tempContent !== this.plan.content;
  }

  build() {
    Column() {
      // Header
      Row() {
        Button('返回')
          .border({ width: 1, color: Theme.ColorBorder, style: BorderStyle.Solid })
          .backgroundColor(Theme.ColorBackground)
          .fontColor(Theme.ColorPrimary)
          .onClick(async () => {
            if (this.isDirty()) {
              // 调用showDialog创建交互式对话框
              const result = await promptAction.showDialog({
                title: '提示', // 对话框标题
                message: '你确定要放弃未保存的内容吗？', // 对话框正文（
                buttons: [
                  { text: '取消', // 按钮文字
                    color: '#666666' // 按钮文字颜色
                  },
                  {
                    text: '确认', color: '#FF4081'
                  }
                ] // 按钮数组，最多支持3个按钮
              });
              if (result.index === 0) {
                // 点击第一个按钮（取消）
              } else if (result.index === 1) {
                // 点击第二个按钮（确认）
                router.back();
              }
            } else {
              router.back();
            }
          })

        Button('保存')
          .backgroundColor(Theme.ColorPrimary)
          .fontColor(Theme.ColorSurface)
          .height(36)
          .border({ width: 1, color: Theme.ColorBorder, style: BorderStyle.Solid })
          .onClick(() => { this.savePlan(); })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: Theme.SpacingMedium, bottom: Theme.SpacingMedium, left: Theme.SpacingMedium, right: Theme.SpacingMedium })
      .backgroundColor(Theme.ColorSurface)
      .border({ width: { bottom: 1 }, color: Theme.ColorBorder })
      if (this.plan) {
        Column() {
          TextInput({ text: this.tempTitle, placeholder: '标题' })
            .fontSize(18)
            .fontColor(Theme.ColorTextPrimary)
            .placeholderColor(Theme.ColorTextSecondary)
            .backgroundColor(Theme.ColorSurface)
            .border({ width: 1, color: Theme.ColorBorder, style: BorderStyle.Solid })
            .margin({ bottom: Theme.SpacingSmall })
            .onChange((v: string) => { this.tempTitle = v; })
            .width('90%')
          Text(this.plan.date)
            .fontSize(12)
            .fontColor(Theme.ColorAccent)
            .margin({ bottom: Theme.SpacingSmall })
          Scroll(){
            Column(){
              TextArea({ text: this.tempContent, placeholder: '内容' })
                .fontSize(16)
                .fontColor(Theme.ColorTextPrimary)
                .placeholderColor(Theme.ColorTextSecondary)
                .lineHeight(24)
                .border({ width: 1, color: Theme.ColorBorder, style: BorderStyle.Solid })
                .width('90%')
                .height('80%')
                .onChange((v: string) => { this.tempContent = v; })
            }
          }
          .scrollBar(BarState.Auto)
        }
        .padding(Theme.SpacingLarge)
        .backgroundColor(Theme.ColorSurface)
        .width('100%')
        .height('100%')
      }
    }
    .backgroundColor(Theme.ColorBackground)
  }
}
