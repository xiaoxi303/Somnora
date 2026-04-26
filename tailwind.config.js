/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        liquid: {
          dark: '#0a0a1a',
          glass: 'rgba(255, 255, 255, 0.05)',
          glassBorder: 'rgba(255, 255, 255, 0.1)',
          glow: 'rgba(120, 160, 255, 0.4)'
        }
      },
      backgroundImage: {
        'liquid-gradient': 'linear-gradient(135deg, #0a0a1a 0%, #1a1a3a 100%)',
      },
      animation: {
        'pulse-slow': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'float': 'float 6s ease-in-out infinite',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        }
      }
    },
  },
  plugins: [],
}
