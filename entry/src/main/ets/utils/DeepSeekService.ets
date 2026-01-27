import http from '@ohos.net.http';

// 定义接口
interface ChatRequestMessage {
  role: string;
  content: string;
}

interface ChatRequestData {
  model: string;
  messages: ChatRequestMessage[];
  temperature?: number;
  max_tokens?: number;
}

// 定义 DeepSeek API 响应的接口
interface DeepSeekResponse {
  choices: Array<DeepSeekChoice>;
}

interface DeepSeekChoice {
  message: DeepSeekMessage;
}

interface DeepSeekMessage {
  content: string;
}

export class DeepSeekService {
  private static readonly API_KEY: string = 'API'; // 替换为你的DeepSeek API密钥
  private static readonly API_URL: string = 'https://api.deepseek.com/v1/chat/completions'; // DeepSeek API地址

  public static async sendMessage(message: string): Promise<string> {
    try {
      // 创建HTTP请求
      let httpRequest = http.createHttp();

      // 准备请求数据
      const requestData: ChatRequestData = {
        model: 'deepseek-chat', // 使用的模型，根据DeepSeek API文档调整
        messages: [
          {
            role: 'user',
            content: message + " 注意，回复我纯文本，不能用markdown格式"
          }
        ],
        temperature: 0.7,
        max_tokens: 1000
      };

      // 发送请求
      let response = await httpRequest.request(
        DeepSeekService.API_URL,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${DeepSeekService.API_KEY}`
          },
          extraData: JSON.stringify(requestData),
          expectDataType: http.HttpDataType.STRING
        }
      );

      // 处理响应
      if (response.responseCode === 200) {
        const responseData: DeepSeekResponse = JSON.parse(response.result.toString());
        if (responseData.choices && responseData.choices.length > 0) {
          return responseData.choices[0].message.content;
        }
        return "No response from AI.";
      } else {
        console.error(`API请求失败，状态码: ${response.responseCode}, 结果: ${response.result}`);
        throw new Error(`API请求失败，状态码: ${response.responseCode}`);
      }
    } catch (error) {
      console.error(`DeepSeek API调用失败: ${JSON.stringify(error)}`);
      return "抱歉，网络有误，请稍后重试";
    }
  }
}
