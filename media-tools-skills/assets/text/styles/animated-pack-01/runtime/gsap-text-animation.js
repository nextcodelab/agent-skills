/**
 * Local, seekable GSAP helper for animated-text-pack-01.
 * The caller supplies the project's locally installed GSAP instance.
 * No remote code, font, or asset is loaded by this module.
 */
export function buildTextTimeline(gsap, element, preset, options = {}) {
  if (!gsap || !element || !preset) throw new Error('gsap, element, and preset are required');
  const style = preset.typography || {};
  const shape = preset.shape || {};
  const animation = preset.animation || {};
  const text = String(options.text ?? element.dataset.text ?? preset.sampleText ?? element.textContent ?? '');
  element.textContent = text;
  element.style.display = 'inline-block';
  element.style.position = 'relative';
  element.style.fontFamily = options.fontFamily || style.fontFamily || 'Arial, sans-serif';
  element.style.fontSize = `${options.fontSize || style.fontSize || 72}px`;
  element.style.fontWeight = String(style.fontWeight || 700);
  element.style.color = options.color || style.color || '#fff';
  element.style.letterSpacing = `${style.letterSpacing || 0}px`;
  element.style.webkitTextStroke = `${style.strokeWidth || 0}px ${style.strokeColor || 'transparent'}`;
  element.style.background = options.background || shape.background || 'transparent';
  element.style.padding = shape.padding || '0';
  element.style.borderRadius = `${shape.borderRadius || 0}px`;
  element.style.transformOrigin = '50% 50%';
  element.style.whiteSpace = 'pre-wrap';
  element.style.willChange = 'transform, opacity, filter, letter-spacing, clip-path';
  if (style.glow) element.style.textShadow = `0 0 10px ${style.accentColor}, 0 0 28px ${style.accentColor}`;

  const duration = options.duration ?? animation.duration ?? 0.55;
  const ease = animation.ease || 'power3.out';
  const tl = gsap.timeline({ paused: true });
  const type = animation.type || 'fade-up';

  const splitWords = () => {
    const words = text.split(/(\s+)/);
    element.replaceChildren(...words.map(part => {
      if (/^\s+$/.test(part)) return document.createTextNode(part);
      const span = document.createElement('span');
      span.className = 'text-style-word';
      span.textContent = part;
      span.style.display = 'inline-block';
      return span;
    }));
    return [...element.querySelectorAll('.text-style-word')];
  };
  const splitChars = () => {
    element.replaceChildren(...Array.from(text).map(char => {
      const span = document.createElement('span');
      span.className = 'text-style-char';
      span.textContent = char === ' ' ? '\u00a0' : char;
      span.style.display = 'inline-block';
      return span;
    }));
    return [...element.querySelectorAll('.text-style-char')];
  };

  switch (type) {
    case 'pop':
      tl.fromTo(element, { autoAlpha: 0, scale: 0.45, rotation: -5 }, { autoAlpha: 1, scale: 1, rotation: 0, duration, ease: 'back.out(1.8)' });
      break;
    case 'fade-up':
      tl.fromTo(element, { autoAlpha: 0, y: 36 }, { autoAlpha: 1, y: 0, duration, ease });
      break;
    case 'typewriter': {
      const chars = splitChars();
      tl.set(element, { autoAlpha: 1 }).from(chars, { autoAlpha: 0, duration: 0.01, stagger: options.stagger ?? 0.035, ease: 'none' });
      break;
    }
    case 'word-stagger':
    case 'split-rise': {
      const words = splitWords();
      tl.from(words, { autoAlpha: 0, y: type === 'split-rise' ? 46 : 20, rotationX: type === 'split-rise' ? -65 : 0, transformOrigin: '50% 100%', duration, stagger: options.stagger ?? 0.11, ease });
      break;
    }
    case 'neon-flicker':
      tl.fromTo(element, { autoAlpha: 0, textShadow: '0 0 0 transparent' }, { autoAlpha: 1, duration: duration * 0.35, textShadow: `0 0 10px ${style.accentColor}, 0 0 28px ${style.accentColor}`, ease: 'steps(2)' })
        .to(element, { autoAlpha: 0.65, duration: 0.06, repeat: 2, yoyo: true, ease: 'none' })
        .to(element, { autoAlpha: 1, duration: duration * 0.25 });
      break;
    case 'marker-wipe': {
      const marker = document.createElement('span');
      marker.className = 'text-style-marker';
      marker.textContent = text;
      marker.style.cssText = `display:inline-block;background:${style.accentColor || '#ffe24a'};padding:0.05em 0.18em;clip-path:inset(0 100% 0 0);`;
      element.replaceChildren(marker);
      element.style.background = 'transparent';
      tl.to(marker, { clipPath: 'inset(0 0% 0 0)', duration, ease });
      break;
    }
    case 'tracking-reveal': {
      const chars = splitChars();
      const spread = options.trackingSpread ?? 16;
      tl.fromTo(chars,
        { autoAlpha: 0, x: (index, target, targets) => (index - (targets.length - 1) / 2) * spread },
        { autoAlpha: 1, x: 0, duration, stagger: options.stagger ?? 0.018, ease });
      break;
    }
    case 'bounce':
      tl.fromTo(element, { autoAlpha: 0, scale: 0.35, y: -24 }, { autoAlpha: 1, scale: 1, y: 0, duration, ease: 'bounce.out' });
      break;
    case 'slide-left':
      tl.fromTo(element, { autoAlpha: 0, x: -56, clipPath: 'inset(0 100% 0 0)' }, { autoAlpha: 1, x: 0, clipPath: 'inset(0 0% 0 0)', duration, ease });
      break;
    case 'glitch':
      tl.fromTo(element, { autoAlpha: 0, x: -10, skewX: -8, filter: 'hue-rotate(90deg)' }, { autoAlpha: 1, x: 0, skewX: 0, filter: 'hue-rotate(0deg)', duration: duration * 0.45, ease: 'steps(4)' })
        .to(element, { x: 3, duration: 0.04, repeat: 3, yoyo: true, ease: 'none' });
      break;
    case 'outline-reveal':
      tl.fromTo(element, { autoAlpha: 0, scale: 1.08, webkitTextStrokeColor: 'transparent' }, { autoAlpha: 1, scale: 1, webkitTextStrokeColor: style.accentColor || style.strokeColor, duration, ease });
      break;
    default:
      tl.fromTo(element, { autoAlpha: 0, y: 24 }, { autoAlpha: 1, y: 0, duration, ease });
  }
  return tl;
}

export function addTextExit(tl, element, preset, at = '+=0') {
  const duration = preset?.animation?.outDuration ?? 0.22;
  tl.to(element, { autoAlpha: 0, y: -10, duration, ease: 'power1.in' }, at);
  return tl;
}
