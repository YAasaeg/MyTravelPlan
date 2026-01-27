import router from '@ohos.router';
import Theme from '../utils/Theme';
import { CustomInput } from '../components/CustomInput';
import { DatabaseManager } from '../db/DatabaseManager';
import promptAction from '@ohos.promptAction';

@Entry
@Component

struct LoginPage {
  @State isLogin: boolean = true;
  @State username: string = '';
  @State password: string = '';
  @State info: string = '';
  @State phone: string = '';
  @State selectedDate: Date = new Date();
  @State formattedDate: string = '';
  @State gender: 'male' | 'female' = 'female';
  async onLogin() {
    if (!this.username || !this.password) {
      promptAction.showToast({ message: '请输入用户名和密码' });
      return;
    }

    const db = DatabaseManager.getInstance();
    if (this.isLogin) {
      const user = await db.login(this.username);
      if (user && user.password === this.password) {
        AppStorage.SetOrCreate('currentUser', user);
        router.replaceUrl({ url: 'pages/Index' });
      } else {
        promptAction.showToast({ message: '用户名或密码错误' });
      }
    } else {
      // Register
      if (this.username.length < 4) {
        promptAction.showToast({ message: '用户名不可小于4位' });
      } else if (this.password.length < 8) {
        promptAction.showToast({ message: '，密码不可小于8位' });
      }
      else if (this.phone.length<11) {
        promptAction.showToast({ message: '电话号码不可小于11位' });
      }
      else{
        const id = await db.register({
          birthday: this.formattedDate,
          gender: this.gender,
          info: this.info,
          password: this.password,
          phone: this.phone,
          username: this.username,
        });
      if (id > 0) {
        promptAction.showToast({ message: '注册成功' });
        this.isLogin = true;
      } else {
        promptAction.showToast({ message: '用户名已存在' });
      }
    }
    }
  }

  async showDatePicker() {
    DatePickerDialog.show({
      start: new Date("1900-1-1"),
      end: new Date(),
      selected: this.selectedDate,
      onDateAccept: (value: Date) => {
        this.selectedDate = value
        // 格式化日期为 YYYY-MM-DD
        const year = this.selectedDate.getFullYear();
        const month = String(this.selectedDate.getMonth() + 1).padStart(2, '0');
        const day = String(this.selectedDate.getDate()).padStart(2, '0');
        this.formattedDate= `${year}-${month}-${day}`;
        console.info("选择的日期: " + this.formattedDate)
      },
      onCancel: () => {
        console.info("取消选择日期")
      }
    })
  }

  build() {

    Column() {
      // 顶部样式
      Column() {
        Text('旅簿')
          .fontSize(28)
          .fontWeight(Theme.FontWeightBold)
          .fontColor(Theme.ColorPrimary)
          .letterSpacing(2)
          .margin({ bottom: Theme.SpacingSmall })

        Text('保存你的旅行计划')
          .fontSize(14)
          .fontColor(Theme.ColorTextSecondary)
          .letterSpacing(1)
      }
      .margin({ top: 50 })
      Scroll(){
      //表单
      Column({ space: Theme.SpacingMedium }) {
        CustomInput({
          placeholder: '用户名',
          text: $username
        })

        CustomInput({
          placeholder: '密码',
          text: $password,
          type: InputType.Password
        })

        if (!this.isLogin) {
          CustomInput({
            placeholder: '简介',
            text: $info
          })
          CustomInput({
            placeholder: '电话',
            text: $phone,
          })

          Row() {
            Text('性别:').margin({right:70})
            Radio({ value: 'F', group: 'sex' })
              .checked(true)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.gender = "female"
                }
              })
            Text('女')
            Radio({ value: 'M', group: 'sex' }).margin({ left: 35 })
              .checked(false).onChange((isChecked: boolean) => {
              if (isChecked) {
                this.gender = "male"
              }
            })
            Text('男')
          }.width('90%')

          Row() {
            Row() {
              Text('出生日期: ' + (this.formattedDate || ''))
                .fontSize(16)
                .width('70%')

              Button('选择')
                .width('20%')
                .onClick(() => {
                  this.showDatePicker()
                })
            }
            .width('90%')
            .margin(10)

          }.justifyContent(FlexAlign.SpaceAround).margin({ top: 10 })
        }

        Button(this.isLogin ? '登录' : '注册')
          .width('100%')
          .height(50)
          .backgroundColor(Theme.ColorPrimary)
          .fontColor(Theme.ColorSurface)
          .fontSize(16)
          .fontWeight(Theme.FontWeightMedium)
          .borderRadius(Theme.RadiusMedium)
          .shadow({ radius: 12, color: 'rgba(0,0,0,0.1)', offsetY: 4 })
          .onClick(() => {
            this.onLogin();
          })
          .margin({ top: Theme.SpacingMedium })

        Text(this.isLogin ? '注册' : '已有账户? 登录')
          .fontSize(14)
          .fontColor(Theme.ColorTextSecondary)
          .decoration({ type: TextDecorationType.Underline, color: Theme.ColorTextSecondary })
          .margin({ top: Theme.SpacingLarge })
          .onClick(() => {
            this.isLogin = !this.isLogin;
          })
      }
      .width('100%')
      .padding({ left: Theme.SpacingLarge, right: Theme.SpacingLarge })
    }.scrollBar(BarState.Off).layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.ColorBackground)
  }
}
