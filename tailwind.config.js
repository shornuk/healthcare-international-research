const plugin = require('tailwindcss/plugin')
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
    darkMode: 'selector',
    content: [
        './templates/**/*.{html,twig}',
    ],
    theme: {
        screens: {
            'xs': '360px',
            ...defaultTheme.screens,
        },
        extend: {
            fontFamily: {
              // sans: ['Inter', ...defaultTheme.fontFamily.sans],
            },
            keyframes: {
                fade: {
                    '0%': { transform: 'translateY(20px)', opacity: '0' },
                    '100%': { transform: 'translateY(0)', opacity: '100%' },
                }
            },
            animation: {
                fade: 'fade 1s ease-in-out',
            }
        },
    },
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
    ],
}
