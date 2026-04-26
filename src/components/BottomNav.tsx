import { useState } from 'react';
import { Home, Moon, BarChart2, Settings } from 'lucide-react';
import { motion } from 'framer-motion';

export default function BottomNav() {
  const [active, setActive] = useState('home');

  const navItems = [
    { id: 'home', icon: Home, label: '概览' },
    { id: 'sleep', icon: Moon, label: '睡眠' },
    { id: 'stats', icon: BarChart2, label: '统计' },
    { id: 'settings', icon: Settings, label: '设置' }
  ];

  return (
    <div className="glass-bottom-bar backdrop-blur-2xl bg-white/5 border border-white/10 shadow-[0_8px_32px_0_rgba(0,0,0,0.3)]">
      {navItems.map((item) => {
        const Icon = item.icon;
        const isActive = active === item.id;
        
        return (
          <button
            key={item.id}
            onClick={() => setActive(item.id)}
            className="relative p-3 rounded-2xl flex flex-col items-center justify-center transition-all duration-300 w-16"
          >
            {isActive && (
              <motion.div
                layoutId="active-bg"
                className="absolute inset-0 bg-white/20 rounded-2xl"
                initial={false}
                transition={{ type: "spring", stiffness: 300, damping: 30 }}
              />
            )}
            <Icon 
              size={24} 
              className={`relative z-10 transition-colors duration-300 ${isActive ? 'text-white' : 'text-white/50'}`} 
            />
            <span className={`text-[10px] mt-1 relative z-10 transition-colors duration-300 ${isActive ? 'text-white' : 'text-white/50'}`}>
              {item.label}
            </span>
          </button>
        );
      })}
    </div>
  );
}
