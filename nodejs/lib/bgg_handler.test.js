import test from 'ava';
import bgg_handler from './bgg_handler';

test('Bgg handler is a promise', t => {
    t.is(bgg_handler.getHot()instanceof Promise, true, "getHot() should be promise (axios get)");
});