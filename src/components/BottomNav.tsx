
import { Home, Moon, BarChart2, Settings } from 'lucide-react';
import { motion } from 'framer-motion';

interface Props {
  activeTab: string;
  setActiveTab: (id: string) => void;
}

export default function BottomNav({ activeTab, setActiveTab }: Props) {

  const navItems = [
    { id: 'home', icon: Home, label: '概览' },
    { id: 'sleep', icon: Moon, label: '睡眠' },
    { id: 'stats', icon: BarChart2, label: '统计' },
    { id: 'settings', icon: Settings, label: '设置' }
  ];

  const currentIndex = navItems.findIndex(i => i.id === activeTab);

  return (
    <div className="glass-bottom-bar backdrop-blur-2xl bg-white/5 border border-white/10 shadow-[0_8px_32px_0_rgba(0,0,0,0.3)]">
      {navItems.map((item, index) => {
        const Icon = item.icon;
        const isActive = activeTab === item.id;
        
        return (
          <button
            key={item.id}
            onClick={() => setActiveTab(item.id)}
            className="relative py-2 px-3 flex flex-col items-center justify-center transition-all duration-300 w-16"
          >
            {isActive && (
              <motion.div
                layoutId="active-bg"
                drag="x"
                dragConstraints={{ left: 0, right: 0 }}
                dragElastic={0.6}
                onDragEnd={(e, info) => {
                  const offset = info.offset.x;
                  const steps = Math.round(offset / 70); // 约70px为一个tab的间距
                  let nextIndex = currentIndex + steps;
                  if (nextIndex < 0) nextIndex = 0;
                  if (nextIndex >= navItems.length) nextIndex = navItems.length - 1;
                  if (nextIndex !== currentIndex) {
                    setActiveTab(navItems[nextIndex].id);
                  }
                }}
                whileDrag={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.3)" }}
                className="absolute inset-0 bg-white/20 rounded-[1.2rem] cursor-grab active:cursor-grabbing z-20"
                initial={false}
                transition={{ type: "spring", stiffness: 300, damping: 30 }}
              />
            )}
            <Icon 
              size={20} 
              className={`relative z-10 pointer-events-none transition-colors duration-300 mb-1 ${isActive ? 'text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.8)]' : 'text-white/50'}`} 
            />
            <span className={`text-[10px] relative z-10 pointer-events-none transition-colors duration-300 ${isActive ? 'text-white' : 'text-white/50'}`}>
              {item.label}
            </span>
          </button>
        );
      })}
    </div>
  );
}
