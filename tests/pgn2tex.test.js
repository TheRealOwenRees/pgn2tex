"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const pgn2tex_helper_1 = require("./pgn2tex_helper");
const pgn2tex_1 = __importDefault(require("../src/pgn2tex"));
describe('Pgn2Tex Class', () => {
    test('should create Pgn2Tex instance', () => {
        const pgn2Tex = new pgn2tex_1.default(pgn2tex_helper_1.pgn, pgn2tex_helper_1.diagrams);
        expect(pgn2Tex).toBeInstanceOf(pgn2tex_1.default);
    });
    // Add more test class/instance tests here
});
describe('Example game', () => {
    test('console.log tex', () => {
        const pgn2tex = new pgn2tex_1.default(pgn2tex_helper_1.pgn, pgn2tex_helper_1.diagrams);
        console.log(pgn2tex.toTex());
    });
});
//# sourceMappingURL=pgn2tex.test.js.map