import { motion } from 'framer-motion';

interface Props {
  progress?: number;
  hours?: string | number;
  minutes?: string | number;
}

export default function SleepRing({ progress = 0.75, hours = "7", minutes = "30" }: Props) {
  const radius = 120;
  const circumference = 2 * Math.PI * radius;
  const strokeDashoffset = circumference - progress * circumference;

  return (
    <div className="relative flex justify-center items-center w-full my-8">
      <div className="relative w-80 h-80 flex justify-center items-center">
        {/* Glow behind the ring */}
        <div className="absolute inset-0 bg-blue-500/20 blur-3xl rounded-full" />
        
        <svg className="w-full h-full transform -rotate-90" viewBox="0 0 300 300">
          {/* Background Track */}
          <circle
            cx="150"
            cy="150"
            r={radius}
            stroke="rgba(255,255,255,0.05)"
            strokeWidth="20"
            fill="transparent"
            className="drop-shadow-lg"
          />
          {/* Progress Ring */}
          <motion.circle
            cx="150"
            cy="150"
            r={radius}
            stroke="url(#gradient)"
            strokeWidth="20"
            fill="transparent"
            strokeLinecap="round"
            initial={{ strokeDashoffset: circumference }}
            animate={{ strokeDashoffset }}
            transition={{ duration: 1.5, ease: "easeOut" }}
            style={{ strokeDasharray: circumference }}
            className="drop-shadow-[0_0_15px_rgba(100,150,255,0.6)]"
          />
          <defs>
            <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#4FACFE" />
              <stop offset="100%" stopColor="#00F2FE" />
            </linearGradient>
          </defs>
        </svg>

        <div className="absolute flex flex-col items-center justify-center">
          <span className="text-white/60 text-sm mb-1 uppercase tracking-widest font-semibold">睡眠时长</span>
          <div className="flex items-baseline">
            <span className="text-6xl font-bold text-transparent bg-clip-text bg-gradient-to-br from-white to-white/70">
              {hours}
            </span>
            <span className="text-xl text-white/50 ml-1">h</span>
            <span className="text-6xl font-bold text-transparent bg-clip-text bg-gradient-to-br from-white to-white/70 ml-2">
              {minutes}
            </span>
            <span className="text-xl text-white/50 ml-1">m</span>
          </div>
          <span className="text-[#00F2FE] text-sm mt-2 font-medium bg-[#00F2FE]/10 px-3 py-1 rounded-full border border-[#00F2FE]/20">
            质量优秀
          </span>
        </div>
      </div>
    </div>
  );
}
