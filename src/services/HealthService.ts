import { Health } from '@awesome-cordova-plugins/health';

export class HealthService {
  static async requestPermissions() {
    try {
      const available = await Health.isAvailable();
      if (!available) {
        console.warn('HealthKit is not available on this device');
        return false;
      }
      
      const permissions = await Health.requestAuthorization([
        { read: ['sleep'] } // 申请读取睡眠数据权限
      ]);
      console.log('Health permissions granted', permissions);
      return true;
    } catch (e) {
      console.error('Error requesting health permissions', e);
      return false;
    }
  }

  static async getSleepData(startDate: Date, endDate: Date) {
    try {
      const data = await Health.query({
        startDate,
        endDate,
        dataType: 'sleep',
      });
      console.log('Sleep data:', data);
      return data;
    } catch (e) {
      console.error('Error fetching sleep data', e);
      return [];
    }
  }
}
