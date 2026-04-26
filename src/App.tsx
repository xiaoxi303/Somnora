import { useEffect, useState } from 'react';
import { Activity, Heart, Wind, Power } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import BottomNav from './components/BottomNav';
import SleepRing from './components/SleepRing';
import StatsGlassCard from './components/StatsGlassCard';
import { HealthService } from './services/HealthService';

function App() {
  const [isSleeping, setIsSleeping] = useState(false);
  const [healthAuthorized, setHealthAuthorized] = useState(false);

  useEffect(() => {
    // 隐藏启动页
    const initApp = async () => {
      // 检查健康数据权限
      const authorized = await HealthService.requestPermissions();
      setHealthAuthorized(authorized);
    };
    initApp();
  }, []);

  const toggleSleep = () => {
    setIsSleeping(!isSleeping);
  };

  return (
    <div className="min-h-screen relative overflow-hidden">
      {/* 动态液态背景 */}
      <div className="fluid-bg" />
      <div className="absolute top-0 right-0 w-96 h-96 bg-purple-500/10 rounded-full blur-[100px] pointer-events-none" />
      <div className="absolute bottom-0 left-0 w-96 h-96 bg-blue-500/10 rounded-full blur-[100px] pointer-events-none" />

      {/* 顶部标题栏 */}
      <header className="pt-16 pb-6 px-6 flex justify-between items-center relative z-10">
        <div>
          <motion.h1 
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-3xl font-bold tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-white to-white/70"
          >
            眠境 Somnara
          </motion.h1>
          <motion.p 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.2 }}
            className="text-white/50 text-sm mt-1 flex items-center"
          >
            {healthAuthorized ? (
              <><span className="w-2 h-2 rounded-full bg-green-400 mr-2 shadow-[0_0_8px_rgba(74,222,128,0.8)]" />健康数据已连接</>
            ) : (
              <><span className="w-2 h-2 rounded-full bg-red-400 mr-2 shadow-[0_0_8px_rgba(248,113,113,0.8)]" />请开启健康权限</>
            )}
          </motion.p>
        </div>
        <div className="w-12 h-12 rounded-full glass flex items-center justify-center border-white/20 overflow-hidden">
          <img src="https://ui-avatars.com/api/?name=User&background=random" alt="User" className="w-full h-full object-cover opacity-80" />
        </div>
      </header>

      {/* 主体内容 */}
      <main className="px-6 relative z-10">
        <SleepRing hours="7" minutes="30" progress={0.8} />

        <div className="flex gap-4 mb-6">
          <StatsGlassCard 
            icon={Activity} 
            title="深度睡眠" 
            value="2.5" 
            unit="h" 
            color="#A78BFA" // Purple
          />
          <StatsGlassCard 
            icon={Heart} 
            title="平均心率" 
            value="58" 
            unit="bpm" 
            color="#F472B6" // Pink
          />
        </div>

        <div className="glass-card mb-24">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center space-x-2">
              <div className="p-2 rounded-xl bg-[#60A5FA]/10 border border-[#60A5FA]/20 text-[#60A5FA]">
                <Wind size={18} />
              </div>
              <span className="text-sm text-white/60 font-medium">呼吸频率</span>
            </div>
            <span className="text-sm font-medium text-[#60A5FA]">14 次/分</span>
          </div>
          
          <div className="h-2 w-full bg-white/5 rounded-full overflow-hidden">
            <motion.div 
              initial={{ width: 0 }}
              animate={{ width: '60%' }}
              transition={{ duration: 1, delay: 0.5 }}
              className="h-full bg-gradient-to-r from-[#3B82F6] to-[#60A5FA] rounded-full relative"
            >
              <div className="absolute top-0 right-0 bottom-0 w-8 bg-white/30 blur-sm mix-blend-overlay" />
            </motion.div>
          </div>
        </div>

        {/* 开始睡眠悬浮按钮 */}
        <div className="fixed bottom-28 left-0 right-0 flex justify-center z-40 pointer-events-none">
          <motion.button
            whileTap={{ scale: 0.95 }}
            onClick={toggleSleep}
            className="pointer-events-auto relative group flex items-center justify-center"
          >
            {/* 发光涟漪效果 */}
            <AnimatePresence>
              {isSleeping && (
                <motion.div
                  initial={{ opacity: 0.8, scale: 0.8 }}
                  animate={{ opacity: 0, scale: 1.5 }}
                  exit={{ opacity: 0 }}
                  transition={{ duration: 2, repeat: Infinity }}
                  className="absolute inset-0 bg-[#00F2FE] rounded-full blur-xl"
                />
              )}
            </AnimatePresence>
            
            <div className={`
              relative w-16 h-16 rounded-full flex items-center justify-center backdrop-blur-xl border transition-all duration-500
              ${isSleeping 
                ? 'bg-[#00F2FE]/20 border-[#00F2FE]/50 text-[#00F2FE] shadow-[0_0_30px_rgba(0,242,254,0.4)]' 
                : 'glass text-white/80 border-white/10 shadow-lg'}
            `}>
              <Power size={24} className={isSleeping ? "drop-shadow-[0_0_8px_rgba(0,242,254,0.8)]" : ""} />
            </div>
          </motion.button>
        </div>
      </main>

      <BottomNav />
    </div>
  );
}

export default App;
