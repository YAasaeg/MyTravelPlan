import relationalStore from '@ohos.data.relationalStore';
import { User } from '../model/User';
import { Plan } from '../model/Plan';
import { ChatMessage } from '../model/ChatMessage';
import common from '@ohos.app.ability.common';

export class DatabaseManager {
  private static instance: DatabaseManager;
  private rdbStore: relationalStore.RdbStore | null = null;
  private context: common.UIAbilityContext | null = null;

  private constructor() {}

  public static getInstance(): DatabaseManager {
    if (!DatabaseManager.instance) {
      DatabaseManager.instance = new DatabaseManager();
    }
    return DatabaseManager.instance;
  }

  public async init(context: common.UIAbilityContext): Promise<void> {
    this.context = context;
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'lvbu.db',
      securityLevel: relationalStore.SecurityLevel.S1
    };

    try {
      this.rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG);
      await this.createTables();
    } catch (err) {
      console.error('Failed to init RdbStore', JSON.stringify(err));
    }
  }

  private async createTables(): Promise<void> {
    if (!this.rdbStore) return;

    // 用户表
    // User Table
    const createUsers = `CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      info TEXT,
      birthday TEXT,
      phone TEXT,
      gender TEXT
    )`;
    await this.rdbStore.executeSql(createUsers);
    // 计划表
    const createPlans = `CREATE TABLE IF NOT EXISTS plans (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT,
      content TEXT,
      date TEXT
    )`;
    await this.rdbStore.executeSql(createPlans);

    // Chat History Table
    const createChat = `CREATE TABLE IF NOT EXISTS chat_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      role TEXT NOT NULL,
      content TEXT NOT NULL,
      timestamp INTEGER NOT NULL
    )`;
    await this.rdbStore.executeSql(createChat);
  }

  // 用户表操作

  public async register(user: User): Promise<number> {
    if (!this.rdbStore) return -1;
    const valueBucket: relationalStore.ValuesBucket = {
      birthday: user.birthday || '错误',
      gender: user.gender || '错误',
      info: user.info || '',
      password: user.password || '',
      phone: user.phone || '错误',
      username: user.username,
    };

    return await this.rdbStore.insert('users', valueBucket);
  }

  public async login(username: string): Promise<User | null> {
    if (!this.rdbStore) return null;
    const predicates = new relationalStore.RdbPredicates('users');
    predicates.equalTo('username', username);

    const resultSet = await this.rdbStore.query(predicates);
    if (resultSet.goToFirstRow()) {
      const user: User = {
        id: resultSet.getLong(resultSet.getColumnIndex('id')),
        username: resultSet.getString(resultSet.getColumnIndex('username')),
        password: resultSet.getString(resultSet.getColumnIndex('password')),
        info: resultSet.getString(resultSet.getColumnIndex('info')),
        phone: resultSet.getString(resultSet.getColumnIndex('phone')),
        birthday: resultSet.getString(resultSet.getColumnIndex('birthday')),
        gender:  resultSet.getString(resultSet.getColumnIndex('gender')),
        //漏了
      };
      resultSet.close();
      return user;
    }
    resultSet.close();
    return null;
  }

  public async updateUser(user: User): Promise<number> {
    if (!this.rdbStore || !user.id) return -1;
    const valueBucket: relationalStore.ValuesBucket = {
      username: user.username,
      password: user.password || '',
      info: user.info || '',
      birthday: user.birthday || '错误',
      phone: user.phone || '错误',
      gender: user.gender || '错误'
    };
    const predicates = new relationalStore.RdbPredicates('users');
    predicates.equalTo('id', user.id);
    return await this.rdbStore.update(valueBucket, predicates);
  }

  // 计划表操作

  public async addPlan(plan: Plan): Promise<number> {
    if (!this.rdbStore) return -1;
    const valueBucket: relationalStore.ValuesBucket = {
      user_id: plan.user_id,
      title: plan.title,
      content: plan.content,
      date: plan.date
    };
    return await this.rdbStore.insert('plans', valueBucket);
  }

  public async getPlans(userId: number): Promise<Plan[]> {
    if (!this.rdbStore) return [];
    const predicates = new relationalStore.RdbPredicates('plans');
    predicates.equalTo('user_id', userId);
    predicates.orderByDesc('date');

    const resultSet = await this.rdbStore.query(predicates);
    const plans: Plan[] = [];
    while (resultSet.goToNextRow()) {
      plans.push({
        id: resultSet.getLong(resultSet.getColumnIndex('id')),
        user_id: resultSet.getLong(resultSet.getColumnIndex('user_id')),
        title: resultSet.getString(resultSet.getColumnIndex('title')),
        content: resultSet.getString(resultSet.getColumnIndex('content')),
        date: resultSet.getString(resultSet.getColumnIndex('date'))
      });
    }
    resultSet.close();
    return plans;
  }

  public async getPlanById(id: number): Promise<Plan | null> {
    if (!this.rdbStore) return null;
    const predicates = new relationalStore.RdbPredicates('plans');
    predicates.equalTo('id', id);
    const resultSet = await this.rdbStore.query(predicates);
    let plan: Plan | null = null;
    if (resultSet.goToFirstRow()) {
      plan = {
        id: resultSet.getLong(resultSet.getColumnIndex('id')),
        user_id: resultSet.getLong(resultSet.getColumnIndex('user_id')),
        title: resultSet.getString(resultSet.getColumnIndex('title')),
        content: resultSet.getString(resultSet.getColumnIndex('content')),
        date: resultSet.getString(resultSet.getColumnIndex('date'))
      };
    }
    resultSet.close();
    return plan;
  }

  public async updatePlan(plan: Plan): Promise<number> {
    if (!this.rdbStore || !plan.id) return -1;
    const now = Date.now();
    const valueBucket: relationalStore.ValuesBucket = {
      title: plan.title,
      content: plan.content,
      date: plan.date,
      updated_at: now
    };
    const predicates = new relationalStore.RdbPredicates('plans');
    predicates.equalTo('id', plan.id);
    try {
      return await this.rdbStore.update(valueBucket, predicates);
    } catch (err) {
      const fallbackBucket: relationalStore.ValuesBucket = {
        title: plan.title,
        content: plan.content,
        date: plan.date
      };
      return await this.rdbStore.update(fallbackBucket, predicates);
    }
  }

  // 聊天记录操作

  public async addChatMessage(message: ChatMessage): Promise<number> {
    if (!this.rdbStore) return -1;
    const valueBucket: relationalStore.ValuesBucket = {
      user_id: message.user_id,
      role: message.role,
      content: message.content,
      timestamp: message.timestamp
    };
    return await this.rdbStore.insert('chat_history', valueBucket);
  }

  public async getChatHistory(userId: number): Promise<ChatMessage[]> {
    if (!this.rdbStore) return [];
    const predicates = new relationalStore.RdbPredicates('chat_history');
    predicates.equalTo('user_id', userId);
    predicates.orderByAsc('timestamp');

    const resultSet = await this.rdbStore.query(predicates);
    const messages: ChatMessage[] = [];
    while (resultSet.goToNextRow()) {
      messages.push({
        id: resultSet.getLong(resultSet.getColumnIndex('id')),
        user_id: resultSet.getLong(resultSet.getColumnIndex('user_id')),
        role: resultSet.getString(resultSet.getColumnIndex('role')) as 'user' | 'assistant',
        content: resultSet.getString(resultSet.getColumnIndex('content')),
        timestamp: resultSet.getLong(resultSet.getColumnIndex('timestamp'))
      });
    }
    resultSet.close();
    return messages;
  }
}
