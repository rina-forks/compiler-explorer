import type {ParseFiltersAndOutputOptions} from '../../types/features/filters.interfaces.js';
import {BaseCompiler} from '../base-compiler.js';

export class BoogieCompiler extends BaseCompiler {
    static get key() {
        return 'boogie';
    }

    override getOutputFilename(dirPath: string): string {
        return this.filename(dirPath + '/boogie.out');
    }

    override optionsForFilter(filters: ParseFiltersAndOutputOptions, outputFilename: string) {
        return [];
    }
}
