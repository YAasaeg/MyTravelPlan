import router from '@ohos.router';
import Theme from '../utils/Theme';
import { User } from '../model/User';
import { DatabaseManager } from '../db/DatabaseManager';
import { CustomInput } from './CustomInput';
import { CustomButton } from './CustomButton';
import promptAction from '@ohos.promptAction';

@Component
export struct ProfileView {
  //@StorageLink('currentUser') currentUser: User = { username: '' };
  @StorageLink('currentUser') currentUser: User | null = null;
  @State editMode: boolean = false;
  @State tempInfo: string = '';
  @State tempPassword: string = '';
  @State tempBirthday: string = '';
  @State selectedDate: Date = new Date();
  @State formattedDate: string = '';
  @State tempPhone: string = '';
  @State tempGender: string = 'female';
  aboutToAppear() {
    this.tempInfo = this.currentUser?.info || '';
    this.tempPassword = this.currentUser?.password || '';
    this.tempBirthday = this.currentUser?.birthday || '';
    this.tempPhone = this.currentUser?.phone || '';
    this.tempGender = this.currentUser?.gender || '';
  }

  async showDatePicker() {
    DatePickerDialog.show({
      start: new Date("2000-1-1"),
      end: new Date(),
      selected: this.selectedDate,
      onDateAccept: (value: Date) => {
        this.selectedDate = value
        // 格式化日期为 YYYY-MM-DD
        const year = this.selectedDate.getFullYear();
        const month = String(this.selectedDate.getMonth() + 1).padStart(2, '0');
        const day = String(this.selectedDate.getDate()).padStart(2, '0');
        this.formattedDate= `${year}-${month}-${day}`;
        this.tempBirthday=this.formattedDate
        console.info("选择的日期: " + this.formattedDate)
      },
      onCancel: () => {
        console.info("取消选择日期")
      }
    })
  }

  async saveChanges() {
    if (this.currentUser?.id) {
      const db = DatabaseManager.getInstance();
      const updatedUser: User = {
        id: this.currentUser.id,
        username: this.currentUser.username,
        password: this.tempPassword,
        info: this.tempInfo,
        birthday: this.tempBirthday,
        phone: this.tempPhone,
        gender: this.tempGender
      };
      
      const result = await db.updateUser(updatedUser);
      if (result >= 0) {
        // 更新数据
        this.currentUser.info = this.tempInfo;
        this.currentUser.password = this.tempPassword;
        this.currentUser.birthday = this.tempBirthday;
        this.currentUser.phone = this.tempPhone;
        this.currentUser.gender = this.tempGender;
        AppStorage.SetOrCreate('currentUser', this.currentUser);
        this.editMode = false;
        promptAction.showToast({ message: '更新成功' });
      } else {
        promptAction.showToast({ message: '更新失败' });
      }
    }
  }

  logout() {
   AppStorage.SetOrCreate('currentUser', null);
    router.pushUrl({ url: 'pages/LoginPage' });
  }

  build() {
    Scroll(){
    Column() {
      // 顶部样式
      Column() {
        Circle({ width: 100, height: 100 })
          .fill(Color.Black)
          .margin({ bottom: Theme.SpacingMedium })

        Text(this.currentUser?.username)
          .fontSize(24)
          .fontWeight(Theme.FontWeightBold)
          .fontColor(Theme.ColorTextPrimary)
      }
      .width('100%')
      .padding({ top: 60, bottom: 40 })
      .backgroundColor(Theme.ColorSurface)
      .border({ width: { bottom: 1 }, color: Theme.ColorBorder })

      // 用户详情
      Column({ space: Theme.SpacingMedium }) {
        if (this.editMode) {
          Text('编辑信息')
            .fontSize(18)
            .fontWeight(Theme.FontWeightMedium)
            .alignSelf(ItemAlign.Start)
          Row(){
          Text('简介:').width('15%').margin({right:3})
          CustomInput({ placeholder: '简介', text: $tempInfo }).width('80%')}
          Row(){
            Text('密码:').width('15%').margin({right:3})
          CustomInput({ placeholder: '密码', text: $tempPassword, type: InputType.Password }).width('80%')}
            Row() {
              Text('生日: ' + ('    '+this.tempBirthday || ''))
              .margin({right:20})
              Button('选择')
                .onClick(() => {
                  this.showDatePicker()
                })
            }.width('95%')
          Row(){
            Text('电话:').width('15%').margin({right:3})
            CustomInput({ placeholder: '电话', text: $tempPhone }).width('80%')}
          Row() {
            Text('性别:').width('15%').margin({right:8})
            Radio({ value: 'F', group: 'sex' })
              .checked(this.tempGender=="female"?true:false)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.tempGender= "female"
                }
              })
            Text('女')
            Radio({ value: 'M', group: 'sex' }).margin({ left: 35 })
              .checked(this.tempGender=="male"?true:false).onChange((isChecked: boolean) => {
              if (isChecked) {
                this.tempGender= "male"
              }
            })
            Text('男')
          }.width('95%')

          Row({ space: Theme.SpacingMedium }) {
            CustomButton({
              text: '取消',
              bgColor: Theme.ColorSecondary,
              widthVal: '45%',
              onClickAction: () => {
                this.editMode = false;
                this.tempInfo = this.currentUser?.info || '';
                this.tempPassword = this.currentUser?.password || '';
              }
            })

            CustomButton({
              text: '保存',
              widthVal: '45%',
              onClickAction: (): Promise<void> => this.saveChanges()
            })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')

        } else {
          // View Mode
          this.InfoRow('简介', this.currentUser?.info || '未提供信息')
          this.InfoRow('生日', this.currentUser?.birthday || '未设置')
          this.InfoRow('电话', this.currentUser?.phone || '未设置')
          this.InfoRow('性别', this.currentUser?.gender === 'female' ? '女' : '男')
          CustomButton({
            text: '编辑信息',
            bgColor: Theme.ColorPrimary,
            onClickAction: () => {
              this.editMode = true;
            }
          })
            .margin({ top: Theme.SpacingLarge })

          CustomButton({
            text: '退出登录',
            bgColor: Theme.ColorBackground,
            textColor: Theme.ColorError,
            onClickAction: (): void => this.logout()
          })
            .margin({ top: Theme.SpacingMedium })
        }
      }
      .padding(Theme.SpacingLarge)
      .width('100%')
      .backgroundColor(Theme.ColorBackground)
    }
  }.scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
  }

  @Builder
  InfoRow(label: string, value: string) {
    Column() {
      Text(label)
        .fontSize(14)
        .fontColor(Theme.ColorTextSecondary)
        .margin({ bottom: 4 })
      Text(value)
        .fontSize(16)
        .fontColor(Theme.ColorTextPrimary)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding(Theme.SpacingMedium)
    .backgroundColor(Theme.ColorSurface)
    .borderRadius(Theme.RadiusMedium)
  }
}
