import { motion } from 'framer-motion';

interface Props {
  icon: React.ElementType;
  title: string;
  value: string | number;
  unit: string;
  color: string;
}

export default function StatsGlassCard({ icon: Icon, title, value, unit, color }: Props) {
  return (
    <motion.div 
      whileHover={{ y: -5 }}
      className="glass-card flex-1 flex flex-col justify-between group"
    >
      <div className="absolute top-0 right-0 w-24 h-24 opacity-20 transform translate-x-8 -translate-y-8 blur-2xl transition-all duration-500 group-hover:opacity-40" style={{ background: color }} />
      
      <div className="flex items-center space-x-2 mb-4">
        <div className="p-2 rounded-xl bg-white/5 border border-white/10" style={{ color }}>
          <Icon size={18} />
        </div>
        <span className="text-sm text-white/60 font-medium">{title}</span>
      </div>
      
      <div className="flex items-end space-x-1">
        <span className="text-3xl font-bold tracking-tight text-white">{value}</span>
        <span className="text-sm text-white/40 mb-1">{unit}</span>
      </div>
    </motion.div>
  );
}
