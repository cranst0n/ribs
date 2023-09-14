import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

export const Highlight = ({ children, color }) => (
  <span
    style={{
      backgroundColor: color,
      borderRadius: '2px',
      color: '#fff',
      padding: '0.2rem',
    }}>
    {children}
  </span>
);

const FeatureList = [
  {
    title: 'Immutable by Default',
    Svg: require('@site/static/img/undraw_powerful_re_frhr.svg').default,
    description: (
      <>
        Immutability brings huge benefits like local reasoning and helps
        eliminate entire classes of bugs that mutable shared state can cause.
      </>
    ),
  },
  {
    title: 'Composable',
    Svg: require('@site/static/img/undraw_building_blocks_re_5ahy.svg').default,
    description: (
      <>
        Ribs is focused on creating small, yet powerful pieces that can
        be combined to create greater functionality while limiting complexity.
      </>
    ),
  },
  {
    title: 'Safety First',
    Svg: require('@site/static/img/undraw_security_on_re_e491.svg').default,
    description: (
      <>
        Every opportunity is taken to use the Dart type system to encode
        variants. The less responsibility on the developer, the better!
      </>
    ),
  },
  {
    title: 'IO for Side Effects',
    Svg: require('@site/static/img/undraw_dev_productivity_re_fylf.svg').default,
    description: (
      <>
        Ribs `IO` type allows you to control your synchronous and asynchronous
        side effects. `IO` is a referentially transparent version of `Future`
        on sterioids!
      </>
    ),
  },
  {
    title: 'Typesafe JSON',
    Svg: require('@site/static/img/undraw_dev_focus_re_6iwt.svg').default,
    description: (
      <>
        <code>Map&lt;String, dynamic&gt;</code> is no longer! Ribs offers completely
        typed JSON.
      </>
    ),
  },
  {
    title: 'Binary Codecs',
    Svg: require('@site/static/img/undraw_convert_re_l0y1.svg').default,
    description: (
      <>
        Encoding and decoding binary data is a breeze with Ribs. Declare
        your codecs and get control over every bit of data!
      </>
    ),
  },
];

function Feature({ Svg, title, description }) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
